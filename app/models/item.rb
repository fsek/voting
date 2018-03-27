# frozen_string_literal: true

# An item on the Agenda
class Item < ApplicationRecord
  # Allow naming column `type`
  self.inheritance_column = :_type_disabled

  acts_as_paranoid
  acts_as_list(scope: [deleted_at: nil])

  has_many(:sub_items, -> { position }, dependent: :destroy,
                                        inverse_of: :item)
  has_many(:votes, through: :sub_items)

  enum(type: { announcement: 0, decision: 5, election: 10 })
  enum(multiplicity: { single: 0, multiple: 10 })

  validates(:title, presence: true)
  validate(:number_of_sub_items, on: :update)

  scope(:position, -> { order(:position) })
  scope(:not_closed, lambda do
    joins(:sub_items).includes(:sub_items).merge(SubItem.not_closed)
  end)

  def self.current
    SubItem.current.try(:item)
  end

  def current?
    sub_items.current.present?
  end

  def status
    return :current if current?
    return :future if sub_items.future.any?
    :closed
  end

  def to_s
    "§#{position} #{title}"
  end

  def list
    str = "§#{position}"
    str += I18n.t('model.item.deleted') if deleted?
    str
  end

  def to_param
    "#{id}-#{title.try(:parameterize)}"
  end

  private

  def number_of_sub_items
    return unless multiplicity_changed? && single? && sub_items.count != 1
    errors.add(:title, I18n.t('model.item.errors.too_many_sub_items'))
    self.multiplicity = :multiple
  end
end
