# frozen_string_literal: true

class SubItem < ApplicationRecord
  acts_as_paranoid
  acts_as_list(scope: [:item_id, deleted_at: nil])
  belongs_to(:item, -> { with_deleted }, inverse_of: :sub_items)
  has_many(:votes, -> { position }, dependent: :destroy)
  has_many_attached(:documents)

  validates(:title, presence: true)
  validates(:status,
            if: :current?,
            uniqueness: {
              message: I18n.t('model.sub_item.errors.already_one_current')
            })
  validate(:number_of_sub_items, on: :create)
  validate(:no_open_votes, on: :update)

  # There is a DB-constraint to assure uniqueness for status < 0,
  # only set statuses that should be unique to values below 0.
  enum(status: { current: -10, future: 0, closed: 10 })
  scope(:position, -> { order(:position) })
  scope(:full_order, lambda do
    joins(:item).order('items.position ASC, sub_items.position ASC')
  end)
  scope(:not_closed, -> { where(status: %i[current future]) })

  def self.current
    where(status: :current).first
  end

  def to_s
    if item.multiple?
      "§#{item.position}.#{position} #{title}"
    else
      item.to_s
    end
  end

  def list
    if item.multiple?
      str = "§#{item.position}.#{position}"
      str += I18n.t('model.item.deleted') if deleted?
      str
    else
      item.list
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private

  def number_of_sub_items
    return if item.multiple? || item.sub_items.select(&:persisted?).empty?
    errors.add(:multiplicity, I18n.t('model.sub_item.errors.count_not_allowed'))
  end

  def no_open_votes
    return unless status_changed?(from: 'current') &&
                  votes.present? &&
                  !votes.current.blank?

    errors.add(:status, I18n.t('model.sub_item.errors.vote_open'))
  end
end
