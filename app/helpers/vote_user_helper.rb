module VoteUserHelper
  def vote_user_state_link(user)
    if user.present?
      if user.presence
        link_to(t('user.make_not_present'), not_present_admin_vote_user_path(user),
                method: :patch)
      else
        link_to(t('user.make_present'), present_admin_vote_user_path(user),
                method: :patch)
      end
    end
  end
end
