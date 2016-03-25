class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, Document, public: true
    can :read, News
    can [:mail, :read], Contact, public: true
    can [:new, :create, :read], Faq
    can [:index, :about, :cookies_information, :lets_encrypt], :static_pages

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update,
           :set_card_number, :update_password,
           :update_account], User, id: user.id
      can [:read, :mail], Contact
      can :read, Document, public: true
      can [:index], Vote
      can [:new, :create], VotePost
    end

    user.permissions.each do |permission|
      can permission.action.to_sym, permission.subject
    end
  end
end
