# frozen_string_literal: true

require 'rails_helper'
RSpec.describe VoteService do
  describe 'user_vote' do
    it 'votes' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open,
                                          choices: 1,
                                          agenda: agenda)
      vote_option = vote.vote_options.first

      vote_post = VotePost.new(user: user, vote: vote, votecode: 'abcd123')
      vote_post.vote_option_ids = [vote_option.id]

      vote_post.should be_valid
      result = false

      lambda do
        result = VoteService.user_vote(vote_post)
        vote_option.reload
      end.should change(vote_option, :count).by(1)

      result.should be_truthy
      vote_post.reload
      vote_post.selected.should eq(1)
    end

    it 'votes and trims votecode' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open,
                                          choices: 1,
                                          agenda: agenda)
      vote_option = vote.vote_options.first

      vote_post = VotePost.new(user: user, vote: vote, votecode: '   abcd123')

      vote_post.vote_option_ids = [vote_option.id]

      # Wrong format on vote_code
      vote_post.should be_invalid
      result = false

      lambda do
        result = VoteService.user_vote(vote_post)
        vote_option.reload
      end.should change(vote_option, :count).by(1)

      result.should be_truthy
      vote_post.reload
      vote_post.selected.should eq(1)
    end

    it 'votes multiple' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open,
                                          choices: 2,
                                          agenda: agenda)
      first_option = vote.vote_options.first
      second_option = vote.vote_options.second

      vote_post = VotePost.new(user: user, vote: vote, votecode: 'abcd123')
      vote_post.vote_option_ids = [first_option.id, second_option.id]

      vote_post.should be_valid
      result = false

      lambda do
        result = VoteService.user_vote(vote_post)
        first_option.reload
      end.should change(first_option, :count).by(1)

      result.should be_truthy
      vote_post.reload
      vote_post.selected.should eq(2)
    end

    it 'invalid vote' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open,
                                          choices: 1,
                                          agenda: agenda)
      # vote has 3 vote options when using :with_options
      first_option = vote.vote_options.first
      last_option = vote.vote_options.last

      vote_post = VotePost.new(user: user, vote: vote, votecode: 'abcd123')
      vote_post.vote_option_ids = [first_option.id, last_option.id]

      vote_post.should_not be_valid
      result = true

      lambda do
        result = VoteService.user_vote(vote_post)
        first_option.reload
      end.should change(first_option, :count).by(0)

      result.should be_falsey
    end

    it 'blank vote' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :open, choices: 1, agenda: agenda)

      opt1 = create(:vote_option, vote: vote, count: 0)
      opt2 = create(:vote_option, vote: vote, count: 0)
      opt3 = create(:vote_option, vote: vote, count: 0)

      vote_post = VotePost.new(user: user, vote: vote, votecode: 'abcd123')
      vote_post.should be_valid

      result = VoteService.user_vote(vote_post)
      opt1.reload
      opt2.reload
      opt3.reload
      vote_post.reload

      result.should be_truthy
      opt1.count.should be(0)
      opt2.count.should be(0)
      opt3.count.should be(0)
      vote_post.selected.should be(0)
    end
  end

  describe 'presence' do
    it 'attends' do
      user = create(:user, presence: false)
      create(:sub_item, status: :current)

      result = VoteService.attends(user)
      user.reload

      result.should be_truthy
      user.presence.should be_truthy
    end

    it 'attends fail if no sub_items' do
      user = create(:user, presence: false)

      result = VoteService.attends(user)
      user.reload

      result.should be_falsey
      user.presence.should be_falsey
    end

    it 'attends fail if no current sub_item' do
      user = create(:user, presence: false)
      create(:sub_item)

      result = VoteService.attends(user)
      user.reload

      result.should be_falsey
      user.presence.should be_falsey
    end

    it 'attends works if a vote is open', pending: true do
      user = create(:user, presence: false)
      sub_item = create(:sub_item, status: :current)
      create(:vote, status: :open, sub_item: sub_item)

      result = VoteService.attends(user)
      user.reload

      result.should be_truthy
      user.presence.should be_truthy
    end

    it 'unattends' do
      user = create(:user, presence: true)
      create(:sub_item, status: :current)

      result = VoteService.unattends(user)
      user.reload

      result.should be_truthy
      user.presence.should be_falsey
    end

    it 'unattends fail if open vote' do
      user = create(:user, presence: true)
      create(:sub_item, status: :current)
      create(:vote, status: :open, agenda: create(:agenda, status: :current))

      result = VoteService.unattends(user)
      user.reload

      result.should be_falsey
      user.presence.should be_truthy
    end

    it 'returns false if no user' do
      user = nil
      create(:sub_item, status: :current)

      present = VoteService.attends(user)
      not_present = VoteService.unattends(user)

      present.should be_falsey
      not_present.should be_falsey
    end
  end

  describe 'set_votecode' do
    it 'sets new votecode' do
      user = create(:user, votecode: 'abcd123')

      result = VoteService.set_votecode(user)
      user.reload

      result.should be_truthy
      user.votecode.should_not eq('abcd123')
    end

    it 'handles nil user' do
      expect(VoteService.set_votecode(nil)).to be_falsey
    end

    it 'does not work if user is not confirmed' do
      user = create(:user, :unconfirmed)

      result = VoteService.set_votecode(user)
      user.reload

      result.should be_falsey
      user.votecode.should be_nil
    end
  end

  describe 'votecode generator' do
    it 'creates good format' do
      VoteService.votecode_generator.should match(/\A[a-z0-9]+\z/)
    end
  end

  describe 'unattend_all' do
    it 'works when votes are closed' do
      create(:vote, status: :closed)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: false)
      create(:sub_item, status: :current)

      result = VoteService.unattend_all
      result.should be_truthy
      User.where(presence: true).count.should eq(0)
    end
  end
end
