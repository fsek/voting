module AgendasHelper
  def agenda_state_link(agenda)
    if agenda.current?
      agenda_close_link(agenda)
    else
      agenda_current_link(agenda)
    end
  end

  def agenda_close_link(agenda)
    link_to(t('agenda.close'), set_closed_admin_agenda_path(agenda),
            method: :patch, remote: true)
  end

  def agenda_current_link(agenda)
    link_to(t('agenda.set_current'), set_current_admin_agenda_path(agenda),
            method: :patch, remote: true)
  end

  def agenda_status_str(state)
    if state == Agenda::CURRENT
      Agenda.human_attribute_name('current')
    elsif state == Agenda::FUTURE
      Agenda.human_attribute_name('future')
    elsif state == Agenda::CLOSED
      Agenda.human_attribute_name('closed')
    else
      ''
    end
  end

  def agenda_status_collection
    [[Agenda.human_attribute_name('future'), Agenda::FUTURE],
     [Agenda.human_attribute_name('current'), Agenda::CURRENT],
     [Agenda.human_attribute_name('closed'), Agenda::CLOSED]]
  end

  def agenda_link(agenda)
    content = [agenda.to_s]

    if agenda.short.present?
      content << ' - '
      content << agenda.short
    end

    if agenda.current?
      content << ''
      content << fa_icon('angle-double-left')
      if agenda.parent.present?
        content << ' '
        content << t('current')
      end
    end

    link_to safe_join(content), agenda_path(agenda)
  end
end
