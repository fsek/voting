# encoding:UTF-8
class UserMailer < Devise::Mailer
  default(template_path: 'devise/mailer')
  helper :application # gives access to all helpers defined within `application_helper`.

  def confirmation_instructions(record, token, opts = {})
    set_message_id
    opts[:subject] = t('user.mailer.subject_confirm', url: PUBLIC_URL)
    @user = record
    super
  end

  def reset_password_instructions(record, token, opts = {})
    set_message_id
    opts[:subject] = t('user.mailer.subject_password', url: PUBLIC_URL)
    @user = record
    super
  end

  def unlock_instructions(record, token, opts = {})
    set_message_id
    super
  end

  def password_change(record, opts = {})
    set_message_id
    super
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
