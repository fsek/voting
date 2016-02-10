class VoteOption < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :vote
  validates :title, presence: true
end
