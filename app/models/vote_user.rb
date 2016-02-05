class VoteUser < ActiveRecord::Base
  validates :name, presence: true
  validates :votecode, presence: true
end
