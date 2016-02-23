class VotePost < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :vote
  belongs_to :user

  attr_accessor :vote_option_ids, :votecode

  validates :vote_id, :votecode, presence: true
  validates :user_id, uniqueness: { scope: :vote }, presence: true
  validate :vote_open, :user_details, :option_details

  def user_details
    unless User.exists?(id: user_id, votecode: votecode, presence: true)
      errors.add(:votecode, I18n.t('vote_post.bad_votecode'))
    end
  end

  def vote_open
    unless vote.open
      errors.add(:votecode, I18n.t('vote_post.vote_closed'))
    end
  end

  def option_details
    if vote_option_ids.present?
      unless vote_option_ids.count <= vote.choices
        errors.add(:vote_option_ids, I18n.t('vote_post.too_many_options'))
      end
      unless vote_option_ids.uniq.count == vote_option_ids.count
        errors.add(:vote_option_ids, I18n.t('vote_post.same_option_twice'))
      end
    else
      errors.add(:vote_option_ids, I18n.t('vote_post.no_option_selected'))
    end
  end
end
