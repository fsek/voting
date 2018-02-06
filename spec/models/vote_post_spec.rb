# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotePost, type: :model do
  context 'user' do
    it 'is unique to vote' do
      user = create(:user, votecode: 'abcd123', presence: true)
      vote = create(:vote, status: :open,
                           sub_item: create(:sub_item, status: :current))
      vote_post = build(:vote_post, user: user,
                                    vote: vote, votecode: user.votecode)
      expect(vote_post).to be_valid
      vote_post.save!
      new_vote_post = build(:vote_post, user: user, vote: vote)
      expect(new_vote_post).to be_invalid
      expect(new_vote_post.errors[:user_id]).to include(t('model.vote_post.already_voted'))
    end

    it 'has valid votecode and presence' do
      user = create(:user, votecode: 'abcd123', presence: true)
      vote_post = build(:vote_post, user: user, votecode: user.votecode)
      vote_post.valid?
      expect(vote_post.errors[:votecode]).to_not \
        include(I18n.t('model.vote_post.bad_votecode_or_presence'))
    end

    it 'fails if user has invalid votecode but is present' do
      user = create(:user, votecode: 'abcd123', presence: true)
      vote_post = build(:vote_post, user: user, votecode: 'something_else')
      vote_post.valid?

      expect(vote_post.errors[:votecode]).to \
        include(I18n.t('model.vote_post.bad_votecode_or_presence'))
    end

    it 'has valid votecode but is not present' do
      user = create(:user, votecode: 'abcd123', presence: false)
      vote_post = build(:vote_post, user: user, votecode: 'abcd123')
      vote_post.valid?

      expect(vote_post.errors[:votecode]).to \
        include(I18n.t('model.vote_post.bad_votecode_or_presence'))
    end
  end

  context 'vote' do
    it 'is open' do
      sub_item = create(:sub_item, status: :current)
      vote = build(:vote, status: :open, sub_item: sub_item)
      vote_post = build(:vote_post, vote: vote)
      vote_post.valid?

      expect(vote_post.errors[:votecode]).to_not \
        include(I18n.t('model.vote_post.vote_closed'))
    end

    it 'is closed' do
      vote = build(:vote, status: :closed)
      vote_post = build(:vote_post, vote: vote)
      vote_post.valid?

      expect(vote_post.errors[:votecode]).to \
        include(I18n.t('model.vote_post.vote_closed'))
    end
  end

  context 'vote_options' do
    it 'has exact amount' do
      vote = build_stubbed(:vote, choices: 3)
      vote_post = build(:vote_post, vote: vote)
      vote_post.vote_option_ids = [1, 2, 3]
      vote_post.valid?

      expect(vote_post.errors[:vote_option_ids]).to_not \
        include(I18n.t('model.vote_post.too_many_options'))
    end

    it 'has less than maximum amount' do
      vote = build_stubbed(:vote, choices: 3)
      vote_post = build(:vote_post, vote: vote)
      vote_post.vote_option_ids = [1, 2]
      vote_post.valid?

      expect(vote_post.errors[:vote_option_ids]).to_not \
        include(I18n.t('model.vote_post.too_many_options'))
    end

    it 'has too many options' do
      vote = build_stubbed(:vote, choices: 1)
      vote_post = build(:vote_post, vote: vote)
      vote_post.vote_option_ids = [1, 2, 3]
      vote_post.valid?

      expect(vote_post.errors[:vote_option_ids]).to \
        include(I18n.t('model.vote_post.too_many_options'))
    end

    it 'has multiple of the same' do
      vote = build_stubbed(:vote, choices: 3)
      vote_post = build(:vote_post, vote: vote)
      vote_post.vote_option_ids = [1, 1, 3]
      vote_post.valid?

      expect(vote_post.errors[:vote_option_ids]).to \
        include(I18n.t('model.vote_post.same_option_twice'))
    end

    it 'does not allow vote options not belonging to vote' do
      vote = build_stubbed(:vote, :with_options, choices: 3)
      expect(vote.vote_options.first.id).to be > 1000

      vote_post = build(:vote_post, vote: vote)
      vote_post.vote_option_ids = [1, vote.vote_options.first.id]
      vote_post.valid?

      expect(vote_post.errors[:vote_option_ids]).to \
        include(I18n.t('model.vote_post.unallowed_options'))
    end
  end
end
