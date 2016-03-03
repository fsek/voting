class Vote < ActiveRecord::Base
  acts_as_paranoid

  has_many :audits, as: :auditable

  has_many :vote_options, dependent: :destroy
  has_many :vote_posts, dependent: :destroy

  validates :title, presence: true
  validates :choices, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validate :only_one_open
  accepts_nested_attributes_for :vote_options, reject_if: :all_blank, allow_destroy: true

  after_create :log_create
  after_update :log_update
  after_destroy :log_destroy

  def self.current
    Vote.where(open: true).first
  end

  def log_create
    log('create')
  end

  def log_update
    if log_changes.present?
      log('update')
    end
  end

  def log_destroy
    log('destroy')
  end

  def log(action)
    Audit.create!(auditable: self, vote_id: id, audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def log_changes
    changes.except(:created_at, :updated_at, :deleted_at, :id, :vote_options)
  end

  def to_s
    %(#{title} (Id: #{id}))
  end

  def updater
    User.current.id if User.current && !destroyed?
  end

  private

  def only_one_open
    if open && Vote.current.present? && Vote.current != self
      errors.add(:open, I18n.t('vote.already_one_open'))
    end
  end
end
