#encoding: UTF-8
class Notice < ActiveRecord::Base
  validates :title, :description, :sort, presence: true

  scope :publik, -> { where(public: true) }
  scope :sorted, -> { order(sort: :asc) }

  def to_s
    title || id
  end
end
