class AdminAbility
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.adjuster?
      can(:manage, Adjustment)
      can(:manage, Agenda)
      can(:manage, :vote_user)
    elsif user.secretary?
      can(:manage, Adjustment)
      can(:manage, Agenda)
      can(:manage, Document)
      can(:manage, :vote_user)
    elsif user.chairman?
      can(:manage, Agenda)
      can(:manage, Vote)
    elsif user.admin?
      can(:manage, :all)
    end
  end
end
