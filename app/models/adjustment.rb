class Adjustment < ActiveRecord::Base
  acts_as_paranoid
  include RankedModel

  belongs_to :agenda, -> { with_deleted }
  belongs_to :user

  validates :agenda_id, :user_id, presence: true

  after_update :log_update
  after_destroy :log_destroy

  ranks :row_order, with_same: :user_id

  private

  def log_update
    if update_changes.present?
      Audit.create!(auditable: self, user_id: user_id, audited_changes: update_changes,
                    action: 'update', updater_id: updater)
    end
  end

  def log_destroy
    Audit.create!(auditable: self, user_id: user_id, audited_changes: destroy_changes,
                  action: 'destroy', updater_id: updater)
  end

  def update_changes
    changes.extract!(:agenda_id, :presence)
  end

  def destroy_changes
    diff = changes.extract!(:agenda_id, :presence)

    if agenda.present? && !diff.key?('agenda_id')
      diff[:name] = agenda.to_s
    end

    diff
  end

  def updater
    User.current.id if User.current && !destroyed?
  end
end
