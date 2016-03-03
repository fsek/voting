# encoding: UTF-8
class VoteMailer < ActionMailer::Base
  default from: 'Röstiga <rostsystem@fsektionen.se>', parts_order: ['text/plain', 'text/html']

  def votecode(user)
    set_message_id
    @user = user
    if @user.present? && @user.email.present?
      mail to: @user.print_email, subject: I18n.t('vote_user.mailer.votecode.subject')
    end
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
