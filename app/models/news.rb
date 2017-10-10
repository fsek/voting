# frozen_string_literal: true

# Information displayed on start page
class News < ApplicationRecord
  belongs_to :user

  # Validations
  validates :title, :content, presence: true

  # Scopes
  scope(:latest, -> { in_date.limit(5) })
  scope(:by_date, -> { order(created_at: :desc) })

  def to_s
    title || id
  end
end
