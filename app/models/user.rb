# encoding:UTF-8
class User < ActiveRecord::Base
  acts_as_paranoid
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable)

  validates :email, uniqueness: true
  validates :email, format: { with: /\A\b[A-Z0-9a-z]{6,8}+@student\.lu\.se\z/,
                              message: I18n.t('user.student_lu_email') }
  validates :firstname, :lastname, presence: true
  validates :votecode, uniqueness: true, allow_nil: true

  # Associations
  has_many :permissions, through: :permission_users
  has_many :permission_users
  has_many :audits, as: :auditable

  after_create :log_create
  after_update :log_update
  after_destroy :log_destroy

  scope :all_firstname, -> { order(firstname: :asc) }
  scope :present, -> { where(presence: true) }
  scope :not_present, -> { where(presence: false) }

  def to_s
    if has_name_data?
      %(#{firstname} #{lastname})
    elsif firstname.present?
      firstname
    else
      email
    end
  end

  # Check if user has user data (name and lastname)
  def has_name_data?
    firstname.present? && lastname.present?
  end

  def print_id
    %(#{self} (Id: #{id}))
  end

  def print_email
    %(#{self} <#{email}>)
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
    Audit.create!(auditable: self, user_id: id, audited_changes: log_changes,
                  action: action, updater_id: updater)
  end

  def log_changes
    changes.extract!(:presence, :votecode)
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
end
