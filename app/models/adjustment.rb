class Adjustment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :agenda
  belongs_to :user

  validates :agenda_id, :user_id, presence: true

  after_update :log_update
  after_destroy :log_destroy

  def log_update
    if log_changes.present?
      log('update')
    end
  end

  def log_destroy
    log('destroy')
  end

  def log(action)
    Audit.create!(auditable: self, user_id: user_id, audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def log_changes
    changes.extract!(:agenda_id, :presence)
  end

  def updater
    User.current.id if User.current && !destroyed?
  end
end
