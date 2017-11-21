# frozen_string_literal: true

# Defines what admins are allowed to do
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.adjuster?
      can(:manage, Adjustment)
      can(:manage, Agenda)
      can(:manage, :attendance)
      can(:manage, :search)
      can(:manage, :vote_user)
      can(:manage, :votecode)
    elsif user.secretary?
      can(:manage, Adjustment)
      can(:manage, Agenda)
      can(:manage, Document)
      can(:manage, :attendance)
      can(:manage, :search)
      can(:manage, :vote_user)
      can(:manage, :votecode)
    elsif user.chairman?
      can(:manage, Agenda)
      can(:manage, Vote)
    elsif user.admin?
      can(:manage, :all)
    end
  end
end
