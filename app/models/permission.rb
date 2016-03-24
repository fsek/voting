class Permission < ActiveRecord::Base
  CUSTOM = ['all', 'vote_user'].freeze
  has_many :permission_users, dependent: :destroy
  has_many :users, through: :permission_users
  validates :subject_class, :action, presence: true

  scope :subject, -> { order(subject_class: :asc) }
  scope :action, -> { order(action: :asc) }

  def to_s
    %(#{subject_class} - #{action})
  end

  def subject
    case subject_class
    when nil
      raise :error
    when *CUSTOM
      subject_class.to_sym
    else
      subject_class.constantize
    end
  end
end
