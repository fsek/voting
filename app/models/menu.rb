# encoding: UTF-8
class Menu < ActiveRecord::Base
  INFO = 'info'.freeze
  VOTING = 'voting'.freeze

  scope :index, -> { order(index: :asc).where(visible: true) }
  validates :name, :location, :link, :index, presence: true

  def to_s
    name
  end
end
