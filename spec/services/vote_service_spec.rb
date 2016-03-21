require 'rails_helper'

RSpec.describe VoteService do
  describe 'user_vote' do
    it 'votes' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, :with_options, status: Vote::OPEN, choices: 1, agenda: agenda)
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

    it 'votes multiple' do
      user = create(:user, presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, :with_options, status: Vote::OPEN, choices: 2, agenda: agenda)
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
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, :with_options, status: Vote::OPEN, choices: 1, agenda: agenda)
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
  end

  describe 'presence' do
    it 'set_present' do
      user = create(:user, presence: false)
      create(:agenda, status: Agenda::CURRENT)

      result = VoteService.set_present(user)
      user.reload

      result.should be_truthy
      user.presence.should be_truthy
    end

    it 'set_present fail if no agendas' do
      user = create(:user, presence: false)

      result = VoteService.set_present(user)
      user.reload

      result.should be_falsey
      user.presence.should be_falsey
    end

    it 'set_present fail if no current agenda' do
      user = create(:user, presence: false)
      create(:agenda)

      result = VoteService.set_present(user)
      user.reload

      result.should be_falsey
      user.presence.should be_falsey
    end

    it 'set_present fail if open vote' do
      user = create(:user, presence: false)
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)

      result = VoteService.set_present(user)
      user.reload

      result.should be_falsey
      user.presence.should be_falsey
    end

    it 'set_not_present' do
      user = create(:user, presence: true)
      create(:agenda, status: Agenda::CURRENT)

      result = VoteService.set_not_present(user)
      user.reload

      result.should be_truthy
      user.presence.should be_falsey
    end

    it 'set_not_present fail if open vote' do
      user = create(:user, presence: true)
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)

      result = VoteService.set_not_present(user)
      user.reload

      result.should be_falsey
      user.presence.should be_truthy
    end

    it 'returns false if no user' do
      user = nil
      create(:agenda, status: Agenda::CURRENT)

      present = VoteService.set_present(user)
      not_present = VoteService.set_not_present(user)

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
      user = nil
      create(:agenda, status: Agenda::CURRENT)
      result = VoteService.set_votecode(user)

      result.should be_falsey
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

  describe 'set_all_not_present' do
    it 'works when votes are closed' do
      create(:vote, status: Vote::CLOSED)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: false)
      create(:agenda, status: Agenda::CURRENT)

      result = VoteService.set_all_not_present
      result.should be_truthy
      User.where(presence: true).count.should eq(0)
    end
  end
end
