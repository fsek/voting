# frozen_string_literal: true

# Model for allowing users to identify and sign in
class User < ApplicationRecord
  acts_as_paranoid
  paginates_per(40)
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable)

  validates :email, uniqueness: true
  validates :email, format: { with: /\A\b[-A-Z0-9a-z]{6,10}+@student\.lu\.se\z/,
                              message: I18n.t('model.user.email_format') }
  validates :firstname, :lastname, presence: true
  validates :votecode, uniqueness: true, allow_nil: true

  validates :card_number, uniqueness: { allow_blank: true },
                          format: { with: /\A\b[0-9]{4}\-[0-9]{4}\-[0-9]{4}\-[0-9]{4}\z/,
                                    message: I18n.t('model.user.card_number_format'),
                                    allow_blank: true }

  validate :presence_require_confirmation, :votecode_require_confirmation

  enum(role: { user: 0, adjuster: 1, secretary: 2, chairman: 3, admin: 4 })

  # Associations
  has_many :audits, as: :auditable
  has_many :adjustments, -> { position }

  after_create :log_create
  after_update :log_update
  after_destroy :log_destroy

  scope :present, -> { where(presence: true) }
  scope :not_present, -> { where(presence: false) }
  scope :all_attended, (lambda do
    includes(adjustments: :sub_item).where.not(adjustments: { id: nil })
  end)

  def self.card_number(card_number)
    return if card_number == '____-____-____-____'
    User.where('card_number LIKE ?', "%#{card_number}%")
  end

  def self.search(options)
    return User.all if options.empty?
    User.fuzzy_search(options.to_h)
  end

  def self.searchable_columns
    %i[firstname lastname email]
  end

  def self.searchable_language
    'swedish'
  end

  def to_s
    %(#{firstname} #{lastname})
  end

  def log_create
    log('create')
  end

  def log_update
    log('update') if log_changes.present?
  end

  def log_destroy
    log('destroy')
  end

  def log(action)
    Audit.create!(auditable: self, user_id: id, audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def log_changes
    saved_changes.extract!(:presence, :votecode)
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end

  def updater
    User.current.id if User.current && !destroyed?
  end

  private

  def presence_require_confirmation
    return unless !confirmed? && presence_changed?(to: true)
    errors.add(:presence, I18n.t('model.user.errors.presence'))
  end

  def votecode_require_confirmation
    return unless !confirmed? && votecode_changed?(from: nil)
    errors.add(:votecode, I18n.t('model.user.errors.votecode'))
  end
end
