# frozen_string_literal: true

# Different options to select during votes
class VoteOption < ApplicationRecord
  acts_as_paranoid

  has_many :audits, as: :auditable

  belongs_to :vote, optional: true
  validates :title, presence: true

  after_create :log_create
  after_update :log_update
  after_destroy :log_destroy

  scope :order_all, -> { with_deleted.order(count: :desc) }

  def log_create
    log('create')
  end

  def log_update
    if log_changes.present?
      log('update')
    end
  end

  def log_destroy
    Audit.create!(auditable: self, vote_id: vote_id, audited_changes: destroy_changes,
                  action: 'destroy', updater_id: updater, skip_presence_validation: true)
  end

  def log(action)
    Audit.create!(auditable: self, vote_id: vote_id, audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def log_changes
    changes.except(:created_at, :updated_at, :deleted_at, :id, :count)
  end

  def destroy_changes
    diff = changes.except(:created_at, :updated_at, :deleted_at, :id, :count)
    unless diff.key?('title')
      diff[:title] = title
    end
    diff
  end

  def updater
    User.current.id if User.current && !destroyed?
  end

  def to_s
    title || id
  end
end
