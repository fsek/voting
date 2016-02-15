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
      val = User.with_deleted.find_by_id(value).print_id
    when 'vote_id'
      val = Vote.with_deleted.find_by_id(value).to_s
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

    content = model.human_attribute_name(key) + ': ' + val.to_s
    content_tag(:p, content)
  end

  def split_votecode(value)
    if value.is_a?(Array) && value.size == 2
      return (value.first.nil? ? t('log.missing') : value.first.to_s) + t('log.to') +
             (value.last.nil? ? t('log.missing') : value.last.to_s)
    else
      return value.nil? ? t('log.missing') : value
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
      t('vote_user.made_present')
    else
      t('vote_user.made_not_present')
    end
  end

  def split_open(value)
    if value.is_a?(Array) && value.size == 2 && value.first != value.last
      return open_closed_string(value.last)
    else
      return yes_no(value)
    end
  end

  def open_closed_string(value)
    if value
      t('vote.made_open')
    else
      t('vote.made_closed')
    end
  end
end
