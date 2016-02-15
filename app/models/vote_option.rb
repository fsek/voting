class VoteOption < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :vote, except: [:count, :deleted_at]

  belongs_to :vote
  validates :title, presence: true
end
