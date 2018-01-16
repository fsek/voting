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
    can %i[index show], Agenda

    # Abilities all signed in users get
    return unless user.id.present?
    can %i[edit show update set_card_number update_password
           update_account], User, id: user.id
    can :show, Document
    can :index, Vote
    can %i[new create], VotePost
  end
end
