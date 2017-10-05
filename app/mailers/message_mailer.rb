require 'digest/sha2'
class MessageMailer < ActionMailer::Base
  default from: 'Röstsystem <dirac@fsektionen.se>'
  default subject: I18n.t('contact.message_sent_via')

  def email(message)
    @message = message
    set_message_id

    recipient = "Röstiga <rostsystem@fsektionen.se>"
    sender = "#{message.name} <#{message.email}>"

    mail(to: recipient, cc: sender, reply_to: sender)
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
