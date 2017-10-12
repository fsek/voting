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

  enum(status: { future: 0, current: 5, closed: 10 })

  validates :title, :status, presence: true
  validates :index, presence: true,
                    numericality: { greater_than_or_equal_to: 1 }
  validate :parent_validation, :only_one_current, :no_open_votes

  scope :by_index, -> { includes(:parent).order(:sort_index) }

  attr_accessor :destroyed_by_parent

  def self.now
    Agenda.current.first
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
      parent.sort_order.to_s + '.' + format('%02d', index).to_s
    else
      format('%02d', index).to_s
    end
  end

  def list_str
    str = '§' + order
    str += I18n.t('agenda.deleted') if deleted?
    str
  end

  def current_status
    closed? && children.current.any? ? :current : status
  end

  def start_page?
    current? || children.closed.count != children.count
  end

  private

  def parent_validation
    p = parent

    until p.nil?
      if p.id == id
        errors.add(:parent_id, I18n.t('agenda.recursion'))
        break
      end
      p = p.parent
    end
  end

  def only_one_current
    return unless current? && Agenda.now.present? && Agenda.now != self
    errors.add(:status, I18n.t('agenda.too_many_open'))
  end

  def no_open_votes
    return unless status_changed?(from: 'current') &&
                  votes.present? &&
                  !votes.current.blank?

    errors.add(:status, I18n.t('agenda.vote_open'))
  end

  def set_sort_index
    self.sort_index = sort_order
  end

  def destroy_validation
    children.each { |child| child.destroyed_by_parent = true }

    if destroyed_by_parent.blank? && (current? || current_child_to?(self))
      errors.add(:destroy, I18n.t('agenda.error_deleting'))
      throw :abort
    end
  end

  def current_child_to?(parent)
    agenda = Agenda.now
    return unless agenda.present?

    while agenda.parent.present?
      agenda.parent == parent ? (return true) : (agenda = agenda.parent)
    end

    false
  end
end
