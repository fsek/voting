class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    user.permissions.each do |permission|
      can(permission.action.to_sym, permission.subject)
    end
  end
end
