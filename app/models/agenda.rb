# frozen_string_literal: true

# An agenda item for displaying the meeting agenda.
class Agenda < ApplicationRecord
  acts_as_paranoid

  before_destroy :destroy_validation # Must be placed above has_many :children!
  before_save :set_sort_index

  has_many :adjustments
  has_many :votes
  has_many :documents, dependent: :nullify
  has_many :children, class_name: 'Agenda',
                      foreign_key: 'parent_id',
                      dependent: :destroy
  belongs_to :parent, class_name: 'Agenda', optional: true

  CURRENT = 'current'
  CLOSED = 'closed'
  FUTURE = 'future'

  validates :title, :status, presence: true
  validates :index, presence: true,
                    numericality: { greater_than_or_equal_to: 1 }
  validate :parent_validation, :only_one_current, :no_open_votes

  scope :index, -> { includes(:parent).order(:sort_index) }

  attr_accessor :destroyed_by_parent

  def self.current
    Agenda.where(status: CURRENT).first
  end

  def to_s
    str = '§' + order + ' ' + title
    str += I18n.t('agenda.deleted') if deleted?
    str
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

  def list_str
    str = '§' + order
    str += I18n.t('agenda.deleted') if deleted?
    str
  end

  def current?
    status == CURRENT
  end

  def current_status
    if status == CLOSED && children.where(status: CURRENT).count.positive?
      CURRENT
    else
      status
    end
  end

  def start_page?
    !(status == CLOSED &&
      children.where(status: CLOSED).count == children.count)
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

  def destroy_validation
    children.each { |child| child.destroyed_by_parent = true }

    if destroyed_by_parent.blank? && (current? || current_child_to?(self))
      errors.add(:destroy, I18n.t('agenda.error_deleting'))
      false
    else
      true
    end
  end

  def current_child_to?(parent)
    agenda = Agenda.current

    if agenda.present?
      while agenda.parent.present?
        (agenda.parent == parent) ? (return true) : (agenda = agenda.parent)
      end
    end

    false
  end
end
