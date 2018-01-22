# frozen_string_literal: true

module VoteUserHelper
  def vote_user_state_link(user)
    return unless user.present?
    if user.presence
      link_to(t('model.vote_user.make_not_present'), admin_attendance_path(user),
              method: :delete, remote: true)
    else
      link_to(t('model.vote_user.make_present'), admin_attendance_path(user),
              method: :patch, remote: true)
    end
  end

  def user_confirmed(user)
    return unless user.present?
    if user.confirmed?
      I18n.l(user.confirmed_at)
    else
      content = safe_join([fa_icon('exclamation-circle'), ' ',
                           I18n.t('model.user.not_confirmed')])
      content_tag(:span, content, class: 'danger')
    end
  end

  def admin_print_user(user)
    return unless user.present?
    content = []
    content << fa_icon('times') unless user.confirmed?
    content << fa_icon('credit-card') <<  ' ' if user.card_number.present?
    content << ' ' << fa_icon('key') << ' ' if user.votecode.present?
    content << user.to_s

    safe_join(content)
  end

  def user_filter
    [[Audit.human_attribute_name('User'), 'User'],
     [Audit.human_attribute_name('VotePost'), 'VotePost'],
     [Audit.human_attribute_name('Adjustment'), 'Adjustment']]
  end

  def user_presence_status(user)
    content = []
    if user.present? && user.presence == true
      content << fa_icon('check-circle-o', class: 'text-success text-4 mr-1')
      content << t('model.vote_user.state.present')
    else
      content << fa_icon('times-circle-o', class: 'text-danger text-4 mr-1')
      content << t('model.vote_user.state.not_present')
    end
    content_tag(:span, safe_join(content), class: 'text-3')
  end
end
