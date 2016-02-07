#encoding: UTF-8
class Notice < ActiveRecord::Base
  # Validations
  validates :title, :description, :sort, presence: true

  # Scopes
  scope :d_published, -> { where('d_publish <= ?', Time.zone.today) }
  scope :not_removed, -> { where('d_remove > ?', Time.zone.today) }
  scope :publik, -> { where(public: true) }
  scope :published, -> { order(sort: :asc).d_published.not_removed }

  # Assures dates are set for queries
  before_create :check_dates
  before_update :check_dates

  # Return: true if notice is valued to display or not
  def displayed?(member: false)
    if member && !public
      displayable_dates
    elsif public
      displayable_dates
    else
      false
    end
  end

  def publicly_displayed?
    public && displayable_dates
  end

  def privately_displayed?
    !public && displayable_dates
  end

  def to_s
    title || id
  end

  private

  def displayable_dates
    time = Time.zone.today
    d_publish <= time && d_remove > time
  end

  # Assures dates are set (if not present) to allow for good queries
  # Also David Wessmans 100th birthday!
  def check_dates
    if d_publish.nil?
      self.d_publish = Time.zone.today
    end
    if d_remove.nil?
      self.d_remove = '2094-03-25'
    end
  end
end
