class Audit < ActiveRecord::Base
  belongs_to :auditable, polymorphic: true
  belongs_to :user, -> { with_deleted }
  belongs_to :updater, class_name: 'User'
  belongs_to :vote, -> { with_deleted }

  validates :auditable, presence: true
end
