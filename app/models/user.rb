# encoding:UTF-8
class User < ActiveRecord::Base
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable)

  validates :email, uniqueness: true
  validates :email, format: { with: /\A\b[A-Z0-9a-z]{6,8}+@student\.lu\.se\z/ }
  validates :firstname, :lastname, presence: true

  # Associations
  has_many :permissions, through: :permission_users
  has_many :permission_users

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
    %(#{self} - #{id})
  end

  def print_email
    %(#{self} <#{email}>)
  end
end
