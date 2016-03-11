module AgendasHelper
  def agenda_state_link(agenda)
    if agenda.current?
      link_to t('agenda.close'), set_closed_admin_agenda_path(agenda), method: :patch
    else
      link_to t('agenda.set_current'), set_current_admin_agenda_path(agenda), method: :patch
    end
  end

  def status_str(state)
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

  def status_collection
    [[Agenda.human_attribute_name('future'), Agenda::FUTURE],
     [Agenda.human_attribute_name('current'), Agenda::CURRENT],
     [Agenda.human_attribute_name('closed'), Agenda::CLOSED]]
  end
end