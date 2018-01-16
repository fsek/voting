# frozen_string_literal: true

class SubItem < ApplicationRecord
  acts_as_paranoid
  acts_as_list(scope: [:item_id, deleted_at: nil])
  belongs_to(:item, inverse_of: :sub_items)
  has_many(:documents, -> { position }, dependent: :destroy)

  validates(:title, presence: true)
  validates(:status,
            if: :current?,
            uniqueness: {
              message: I18n.t('model.sub_item.errors.already_one_current')
            })
  validate(:number_of_sub_items, on: :create)

  # There is a DB-constraint to assure uniqueness for status < 0,
  # only set statuses that should be unique to values below 0.
  enum(status: { current: -10, future: 0, closed: 10 })
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
