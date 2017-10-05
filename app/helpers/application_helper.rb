module ApplicationHelper
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
    link_to(safe_join([title, ' ', fa_icon('angle-down')]),
            '#',
            class: 'dropdown-toggle',
            data: { toggle: 'dropdown',
                    hover: 'dropdown',
                    delay: '0',
                    close_others: 'false' })
  end
end
