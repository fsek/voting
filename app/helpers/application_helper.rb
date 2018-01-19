# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    case level
    when "notice" then "alert-info"
    when "success" then "alert-success"
    when "error" then "alert-danger"
    when "alert" then "alert-warning"
    end
  end

  def yes_no(value)
    if value
      I18n.t('yes')
    else
      I18n.t('no')
    end
  end

  def model_name(model)
    model.model_name.human if model.instance_of?(Class)
  end

  def models_name(model)
    model.model_name.human(count: 2) if model.instance_of?(Class)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def full_title(page_title)
    base_title = 'Röstsystem'
    if page_title.empty?
      base_title
    else
      %(#{base_title} | #{page_title})
    end
  end

  def menu_dropdown_link(title)
    link_to(title,
            '#',
            class: 'nav-link dropdown-toggle',
            data: { toggle: 'dropdown' },
            aria: { haspopup: true, expanded: false })
  end
end
