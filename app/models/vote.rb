class Vote < ActiveRecord::Base
  acts_as_paranoid
  audited except: :deleted_at
  has_associated_audits

  has_many :vote_options, dependent: :destroy
  has_many :vote_posts, dependent: :destroy
  validates :title, presence: true
  accepts_nested_attributes_for :vote_options, reject_if: :all_blank, allow_destroy: true

  def to_s
    %(#{title} (Id: #{id}))
  end
end
