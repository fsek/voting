class VotePost < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :vote
  belongs_to :user

  attr_accessor :vote_option_id, :votecode

  validates :vote_id, :votecode, presence: true
  validates :user_id, uniqueness: { scope: :vote }, presence: true
  validate :vote_open, :user_details

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
end
