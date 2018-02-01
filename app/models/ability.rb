# frozen_string_literal: true

# Defines what users are allowed to do
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, News
    can %i[mail read], :contact
    can %i[index about cookies_information terms], :static_pages
    can %i[index show], Item

    # Abilities all signed in users get
    return unless user.id.present?
    can %i[show update account update_account password update_password], User
    can :index, Vote
    can %i[new create], VotePost
  end
end
