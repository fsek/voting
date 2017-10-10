# frozen_string_literal: true

# Delivers vote codes to users
class VoteMailer < ApplicationMailer
  def votecode(user)
    set_message_id
    @user = user
    return unless @user.present? && @user.email.present?
    mail(to: @user.print_email,
         subject: I18n.t('vote_user.mailer.votecode.subject'))
  end
end
