module VoteUserHelper
  def vote_user_state_link(user)
    if user.present?
      if user.presence
        link_to(t('user.make_not_present'), not_present_admin_vote_user_path(user),
                method: :patch, remote: true)
      else
        link_to(t('user.make_present'), present_admin_vote_user_path(user),
                method: :patch, remote: true)
      end
    end
  end

  def user_confirmed(user)
    if user.present?
      if user.confirmed?
        I18n.l(user.confirmed_at)
      else
        content = safe_join([fa_icon('exclamation-circle'), ' ',
                             I18n.t('user.not_confirmed')])
        content_tag(:span, content, class: 'danger')
      end
    end
  end

  def admin_print_user(user)
    if user.present?
      if user.confirmed?
        user
      else
        safe_join([fa_icon('times'), ' ', user])
      end
    end
  end
end
