# frozen_string_literal: true

module ItemsHelper
  def item_type(type)
    t("model.item.types.#{type}")
  end

  def item_types
    Item.types.keys.map { |t| [item_type(t), t] }
  end

  def item_multiplicity(type)
    t("model.item.multiplicities.#{type}")
  end

  def item_status(status)
    t("model.sub_item.statuses.#{status}")
  end

  def item_type_icon(type)
    case type
    when 'decision'
      'gavel'
    when 'election'
      'check'
    when 'announcement'
      'info-circle'
    end
  end

  def current_item_button(sub_item)
    return if sub_item.nil?
    case sub_item.status
    when 'future'
      button_to(t('model.sub_item.set_current'),
                admin_current_item_path(sub_item),
                method: :patch, remote: true, class: 'btn primary')
    when 'current'
      button_to(t('model.sub_item.close'),
                admin_current_item_path(sub_item),
                method: :delete, remote: true, class: 'btn danger')
    when 'closed'
      button_to(t('model.sub_item.reopen'),
                admin_current_item_path(sub_item),
                method: :patch, remote: true, class: 'btn secondary')
    end
  end

  def item_link(item)
    content = [item.to_s]
    content << '' << fa_icon('angle-double_left') if item.current?

    link_to safe_join(content), item_path(item)
  end

  def item_badge(item)
    classes = 'badge badge-pill text-1'
    classes += ' badge-primary' if item.status == :open
    classes += ' badge-info' if item.status == :future
    classes += ' badge-light' if item.status == :closed
    content_tag(:span, item_status(item.status), class: classes)
  end
end
