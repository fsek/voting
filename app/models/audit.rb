# frozen_string_literal: true

# For creating auditing logs of all changes
class Audit < ApplicationRecord
  belongs_to :auditable, -> { with_deleted }, polymorphic: true
  belongs_to :user, -> { with_deleted }, optional: true
  belongs_to :updater, class_name: 'User', optional: true
  belongs_to :vote, -> { with_deleted }, optional: true

  attr_accessor :skip_presence_validation

  validates :auditable, presence: true, unless: :skip_validation?

  def skip_validation?
    skip_presence_validation
  end
end
