class VoteUser < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :votecode, presence: true
end
