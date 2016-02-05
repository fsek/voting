class Permission < ActiveRecord::Base
  has_many :users, through: :permission_users
  has_many :permission_users
  validates :subject_class, :action, presence: true

  scope :subject, -> { order(subject_class: :asc) }

  def to_s
    %(#{subject_class} - #{action})
  end
end
