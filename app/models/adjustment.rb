# frozen_string_literal: true

# Presence adjustment for Voters
class Adjustment < ApplicationRecord
  acts_as_paranoid
  include RankedModel
  paginates_per(100)

  belongs_to :sub_item, -> { with_deleted }
  belongs_to :user

  after_update :log_update
  after_destroy :log_destroy

  ranks :row_order, with_same: :user_id

  private

  def log_update
    return unless update_changes.present?
    Audit.create!(auditable: self, user_id: user_id,
                  audited_changes: update_changes,
                  action: 'update', updater_id: updater)
  end

  def log_destroy
    Audit.create!(auditable: self, user_id: user_id,
                  audited_changes: destroy_changes,
                  action: 'destroy', updater_id: updater)
  end

  def update_changes
    saved_changes.extract!(:sub_item_id, :presence)
  end

  def destroy_changes
    diff = saved_changes.extract!(:sub_item_id, :presence)
    diff[:name] = sub_item.to_s if sub_item.present? && !diff.key?('sub_item_id')
    diff
  end

  def updater
    User.current.id if User.current && !destroyed?
  end
end
