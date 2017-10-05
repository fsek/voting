class Message
  include ActiveModel::Model

  attr_accessor :message, :name, :email
  attr_reader :errors

  def initialize(attributes = {}, _options = {})
    @errors = ActiveModel::Errors.new(self)
    @message = attributes[:message]
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def send!
    if MessageValidator.validate(self)
      MessageMailer.email(self).deliver_now
      true
    else
      false
    end
  end
end
