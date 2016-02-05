class VotePost < ActiveRecord::Base
  belongs_to :vote
  validates :vote_id, presence: true
  validates :votecode, uniqueness: {scope: :vote}, presence: true
  validate :vote_open, :user_details

  attr_accessor :vote_option_id
  
  def user_details
    unless VoteUser.exists?(votecode: votecode, present: true)
      errors.add(:votecode, I18n.t('vote_post.bad_votecode'))
    end
  end

  def vote_open
    unless vote.open
      errors.add(:votecode, I18n.t('vote_post.vote_closed'))
    end
  end
end