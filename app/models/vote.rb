class Vote < ActiveRecord::Base
  acts_as_paranoid

  has_many :vote_options, dependent: :destroy
  has_many :vote_posts, dependent: :destroy
  validates :title, presence: true
  validates :choices, presence: true, numericality: { greater_than_or_equal_to: 1 }
  accepts_nested_attributes_for :vote_options, reject_if: :all_blank, allow_destroy: true
end
