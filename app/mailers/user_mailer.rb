# frozen_string_literal: true

# Delivers emails to users regarding their accounts
class UserMailer < Devise::Mailer
  default(template_path: 'devise/mailer')
  # gives access to all helpers defined within `application_helper`.
  helper(EmailHelper)
  layout('email')

  def confirmation_instructions(record, token, opts = {})
    set_message_id
    opts[:subject] = t('users_mailer.subject_confirm', title: t('general.title'))
    @user = record
    super
  end

  def reset_password_instructions(record, token, opts = {})
    set_message_id
    opts[:subject] = t('users_mailer.subject_password', title: t('general.title'))
    @user = record
    super
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@rostsystem.se>"
  end
end
