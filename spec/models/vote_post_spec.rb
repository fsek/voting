# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotePost, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it 'belongs_to vote' do
      VotePost.new.should belong_to(:user)
    end

    it 'belongs_to user' do
      VotePost.new.should belong_to(:user)
    end

    it 'has_many audits' do
      VotePost.new.should have_many(:audits)
    end
  end

  describe 'validations' do
    context 'user' do
      it 'is present' do
        agenda = create(:agenda, status: :current)
        create(:vote, status: :open, agenda: agenda)
        vote_post = build(:vote_post)

        vote_post.should validate_presence_of(:user_id)
      end

      it 'is unique to vote' do
        agenda = create(:agenda, status: :current)
        vote = create(:vote, status: :open, agenda: agenda)
        vote_post = build(:vote_post, user: user, vote: vote)
        vote_post.should validate_uniqueness_of(:user_id).scoped_to(:vote_id).with_message(I18n.t('vote_post.already_voted'))
      end

      it 'has valid votecode and presence' do
        user = create(:user, votecode: 'abcd123', presence: true)
        vote_post = build(:vote_post, user: user, votecode: 'abcd123')
        vote_post.valid?

        vote_post.errors[:votecode].should_not include(I18n.t('vote_post.bad_votecode_or_presence'))
      end

      it 'has invalid votecode but is present' do
        user = create(:user, votecode: 'abcd123', presence: true)
        vote_post = build(:vote_post, user: user, votecode: 'something_else')
        vote_post.valid?

        vote_post.errors[:votecode].should include(I18n.t('vote_post.bad_votecode_or_presence'))
      end

      it 'has valid votecode but is not present' do
        user = create(:user, votecode: 'abcd123', presence: false)
        vote_post = build(:vote_post, user: user, votecode: 'abcd123')
        vote_post.valid?

        vote_post.errors[:votecode].should include(I18n.t('vote_post.bad_votecode_or_presence'))
      end
    end

    context 'vote' do
      it 'is present' do
        vote_post = build(:vote_post)

        vote_post.should validate_presence_of(:vote_id)
      end

      it 'is open' do
        agenda = create(:agenda, status: :current)
        vote = build(:vote, status: :open, agenda: agenda)
        vote_post = build(:vote_post, vote: vote)
        vote_post.valid?

        vote_post.errors[:votecode].should_not include(I18n.t('vote_post.vote_closed'))
      end

      it 'is closed' do
        vote = build(:vote, status: :closed)
        vote_post = build(:vote_post, vote: vote)
        vote_post.valid?

        vote_post.errors[:votecode].should include(I18n.t('vote_post.vote_closed'))
      end
    end

    context 'vote_options' do
      it 'has exact amount' do
        vote = build_stubbed(:vote, choices: 3)
        vote_post = build(:vote_post, vote: vote)
        vote_post.vote_option_ids = [1, 2, 3]
        vote_post.valid?

        vote_post.errors[:vote_option_ids].should_not include(I18n.t('vote_post.too_many_options'))
      end

      it 'has less than maximum amount' do
        vote = build_stubbed(:vote, choices: 3)
        vote_post = build(:vote_post, vote: vote)
        vote_post.vote_option_ids = [1, 2]
        vote_post.valid?

        vote_post.errors[:vote_option_ids].should_not include(I18n.t('vote_post.too_many_options'))
      end

      it 'has too many options' do
        vote = build_stubbed(:vote, choices: 1)
        vote_post = build(:vote_post, vote: vote)
        vote_post.vote_option_ids = [1, 2, 3]
        vote_post.valid?

        vote_post.errors[:vote_option_ids].should include(I18n.t('vote_post.too_many_options'))
      end

      it 'has multiple of the same' do
        vote = build_stubbed(:vote, choices: 3)
        vote_post = build(:vote_post, vote: vote)
        vote_post.vote_option_ids = [1, 1, 3]
        vote_post.valid?

        vote_post.errors[:vote_option_ids].should include(I18n.t('vote_post.same_option_twice'))
      end

      it 'does not allow vote options not belonging to vote' do
        vote = build_stubbed(:vote, :with_options, choices: 3)
        vote.vote_options.first.id.should > 1000

        vote_post = build(:vote_post, vote: vote)
        vote_post.vote_option_ids = [1, vote.vote_options.first.id]
        vote_post.valid?

        vote_post.errors[:vote_option_ids].should include(I18n.t('vote_post.unallowed_options'))
      end
    end
  end
end
