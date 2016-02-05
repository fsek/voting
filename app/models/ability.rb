class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Abilities that everyone get.
    can :read, Document, public: true
    can :read, News
    can [:mail, :read], Contact, public: true
    can [:display, :image], Notice
    can [:new, :create, :read], Faq
    can [:index, :about, :cookies_information], :static_pages

    # Abilities all signed in users get
    if user.id.present?
      can [:edit, :show, :update, :update_password, :update_account], User, id: user.id
      can [:read, :mail], Contact
      can :read, Document, public: true
      can [:index], Vote
      can [:new, :create], VotePost
    end

    # Add abilities gained from posts
    user.permissions.each do |permission|
      if permission.subject_class == 'all'
        can permission.action.to_sym, :all
      else
        can permission.action.to_sym, permission.subject_class.constantize
      end
    end
  end
end
