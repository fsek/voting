module VotesHelper
  def split_audit_hashes(input, model)
    values = []
    input.each do |key, value|
      values << split_hash(key, value, model)
    end
    safe_join(values)
  end

  def split_hash(key, value, model)
    val = ''
    case key
    when 'user_id'
      val = split_array(value)
    when 'vote_id'
      val = split_array(value)
    when 'agenda_id'
      val = split_agenda(value)
    when 'presence'
      val = split_presence(value)
    when 'votecode'
      val = split_votecode(value)
    when 'open'
      val = split_open(value)
    when 'title'
      val = split_votecode(value)
    else
      val = value.to_s
    end

    unless val.blank?
      content = model.human_attribute_name(key) + ': ' + val.to_s
      content_tag(:p, content)
    end
  end

  def split_votecode(value)
    if value.is_a?(Array) && value.size == 2
      return (value.first.nil? ? t('log.missing') : value.first.to_s) + t('log.to') +
             (value.last.nil? ? t('log.missing') : value.last.to_s)
    else
      return value.nil? ? t('log.missing') : value
    end
  end

  def split_array(value)
    unless value.is_a?(Array) && value.first.nil?
      return value.to_s
    end
  end

  def split_presence(value)
    if value.is_a?(Array) && value.size == 2 && value.first != value.last
      return presence_string(value.last)
    else
      return yes_no(value)
    end
  end

  def presence_string(value)
    if value
      t('vote_user.state.present')
    else
      t('vote_user.state.not_present')
    end
  end

  def split_open(value)
    if value.is_a?(Array) && value.size == 2 && value.first != value.last
      return open_closed_string(value.last)
    else
      return yes_no(value)
    end
  end

  def split_agenda(value)
    if value.is_a?(Array) && value.size == 2
      '§' + Agenda.find(value.first).order + t('log.to') + '§' + Agenda.find(value.last).order
    else
      value.to_s
    end
  end

  def open_closed_string(value)
    if value
      t('vote.made_open')
    else
      t('vote.made_closed')
    end
  end

  def vote_state_link(vote)
    if vote.present?
      if vote.open
        link_to(t('vote.do_close'), close_admin_vote_path(vote),
                method: :patch)
      else
        link_to(t('vote.do_open'), open_admin_vote_path(vote),
                method: :patch)
      end
    end
  end

  def vote_str(votes, id)
    votes.find_by_id(id).to_s
  end

  def vote_option_str(option)
    if option.deleted?
      option.title + t('vote.deleted')
    else
      option.title
    end
  end

  def user_filter
    [[Audit.human_attribute_name('User'), 'User'],
     [Audit.human_attribute_name('VotePost'), 'VotePost'],
     [Audit.human_attribute_name('Adjustment'), 'Adjustment']]
  end

  def vote_filter
    [[Audit.human_attribute_name('Vote'), 'Vote'],
     [Audit.human_attribute_name('VoteOption'), 'VoteOption'],
     [Audit.human_attribute_name('VotePost'), 'VotePost']]
  end
end
