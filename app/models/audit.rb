class Audit < ActiveRecord::Base
  belongs_to :auditable, -> { with_deleted }, polymorphic: true
  belongs_to :user, -> { with_deleted }
  belongs_to :updater, class_name: 'User'
  belongs_to :vote, -> { with_deleted }

  attr_accessor :skip_presence_validation

  validates :auditable, presence: true, unless: :skip_validation?

  def skip_validation?
    skip_presence_validation
  end
end
