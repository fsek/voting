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
    str = ''

    if user.present?
      if !user.confirmed?
        str = safe_join(fa_icon(['times', ' ']))
      elsif user.card_number.present?
        str = safe_join([fa_icon('credit-card'), ' '])
      end

      if user.votecode.present?
        str += safe_join([' ', fa_icon('key'), ' '])
      end

      str += user
    end

    str
  end

  def user_filter
    [[Audit.human_attribute_name('User'), 'User'],
     [Audit.human_attribute_name('VotePost'), 'VotePost'],
     [Audit.human_attribute_name('Adjustment'), 'Adjustment']]
  end

  def user_presence_status(user)
    if user.present? && user.presence == true
      content_tag(:span, class: 'present') do
        safe_join([fa_icon('check-circle-o'), ' ', t('vote_user.state.present')])
      end
    else
      content_tag(:span, class: 'not-present') do
        safe_join([fa_icon('times-circle-o'), ' ', t('vote_user.state.not_present')])
      end
    end
  end
end
