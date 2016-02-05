class VoteOption < ActiveRecord::Base
  belongs_to :vote
  validates :title, presence: true
end
