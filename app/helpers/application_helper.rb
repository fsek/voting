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

  def form_group &block
    html = Nokogiri::HTML.fragment capture_haml &block
    html.xpath('input|textarea').each do |e|
      if e['class']
        e['class'] += ' form-control '
      else
        e['class'] = 'form-control '
      end
    end
    content_tag :div, raw(html.to_html), class: 'form-group'
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
