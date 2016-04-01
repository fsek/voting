module UserHelper
  def user_email_hint
    simple_format(t('user.visibility.email') + '<br>' + t('user.email_format'))
  end
end
