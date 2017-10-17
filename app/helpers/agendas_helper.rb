module AgendasHelper
  def agenda_state_link(agenda)
    if agenda.current?
      agenda_close_link(agenda)
    else
      agenda_current_link(agenda)
    end
  end

  def agenda_close_link(agenda)
    link_to(t('agenda.close'), admin_current_agenda_path(agenda),
            method: :delete, remote: true)
  end

  def agenda_current_link(agenda)
    link_to(t('agenda.set_current'), admin_current_agenda_path(agenda),
            method: :patch, remote: true)
  end

  def agenda_status_str(state)
    t("model.agenda.statuses.#{state}")
  end

  def agenda_status_collection
    Agenda.statuses.keys.map do |s|
      [agenda_status_str(s), s]
    end
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
