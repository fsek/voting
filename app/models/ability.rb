class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, Document, public: true
    can :read, News
    can [:mail, :read], Contact
    can [:index, :about, :cookies_information, :terms], :static_pages

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update,
           :set_card_number, :update_password,
           :update_account], User, id: user.id
      can :read, Document
      can [:index], Vote
      can [:new, :create], VotePost
    end
  end
end
