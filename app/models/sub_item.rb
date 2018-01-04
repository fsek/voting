# frozen_string_literal: true

class SubItem < ApplicationRecord
  acts_as_paranoid
  acts_as_list(scope: [:item_id, deleted_at: nil])
  belongs_to(:item, inverse_of: :sub_items)

  validates(:title, presence: true)
  validate(:number_of_sub_items, on: :create)

  enum(status: { future: 0, current: 10, closed: 20 })
  scope(:position, -> { order(:position) })

  def to_s
    "§#{item.position}.#{position} #{title}"
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private

  def number_of_sub_items
    return if item.multiple? || item.sub_items.select(&:persisted?).empty?
    errors.add(:multiplicity, I18n.t('model.sub_item.errors.count_not_allowed'))
  end
end
