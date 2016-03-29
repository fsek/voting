# encoding: UTF-8
class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :email, :text, presence: true
  validates :email, uniqueness: true, format: { with: Devise::email_regexp }
  validates :slug, uniqueness: { allow_blank: true }

  attr_accessor :message

  def send_email
    if message.validate!
      ContactMailer.contact_email(self).deliver_now
      true
    else
      false
    end
  end

  def to_s
    name
  end
end
