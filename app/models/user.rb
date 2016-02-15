# encoding:UTF-8
class User < ActiveRecord::Base
  acts_as_paranoid
  audited only: [:presence, :votecode]

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
  has_many :vote_posts

  scope :all_firstname, -> { order(firstname: :asc) }

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
end
