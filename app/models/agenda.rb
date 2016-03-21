class Agenda < ActiveRecord::Base
  acts_as_paranoid

  has_many :adjustments
  has_many :votes
  has_many :children, class_name: 'Agenda', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Agenda'

  CURRENT = 'current'.freeze
  CLOSED = 'closed'.freeze
  FUTURE = 'future'.freeze

  validates :title, :status, presence: true
  validates :index, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validate :parent_validation, :only_one_current, :no_open_votes

  scope :index, -> { order(:sort_index) }

  before_save :set_sort_index

  def self.current
    Agenda.where(status: CURRENT).first
  end

  def to_s
    '§' + order + ' ' + title
  end

  def order
    if parent
      parent.order.to_s + '.' + index.to_s
    else
      index.to_s
    end
  end

  def sort_order
    if parent
      parent.sort_order.to_s + '.' + ('%02d' % index).to_s
    else
      ('%02d' % index).to_s
    end
  end

  def current?
    status == CURRENT
  end

  def current_status
    if status == CLOSED && children.where(status: CURRENT).first
      CURRENT
    else
      status
    end
  end

  private

  def parent_validation
    p = parent

    while !p.nil?
      if p.id == id
        errors.add(:parent_id, I18n.t('agenda.recursion'))
        break
      end
      p = p.parent
    end
  end

  def only_one_current
    if current? && Agenda.current.present? && Agenda.current != self
      errors.add(:status, I18n.t('agenda.too_many_open'))
    end
  end

  def no_open_votes
    if status_changed?(from: CURRENT) && votes.present?
      unless votes.current.blank?
        errors.add(:status, I18n.t('agenda.vote_open'))
      end
    end
  end

  def set_sort_index
    self.sort_index = sort_order
  end
end
