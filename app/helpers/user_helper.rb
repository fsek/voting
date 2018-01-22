# frozen_string_literal: true

module UserHelper
  def user_roles
    User.roles.keys.sort.map { |c| [user_role(c), c] }
  end

  def user_role(role)
    t("model.user.roles.#{role}")
  end
end
