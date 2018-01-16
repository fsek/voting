# frozen_string_literal: true

module UserHelper
  def user_email_hint
    simple_format(t('user.visibility.email') + '<br>' + t('user.email_format'))
  end

  def user_roles
    res = []
    User.roles.keys.sort.each do |c|
      res << [user_role(c), c]
    end
    res
  end

  def user_role(role)
    t("model.user.roles.#{role}")
  end
end
