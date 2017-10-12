module VoteService
  def self.user_vote(post)
    VotePost.transaction do
      if post.vote_option_ids.present?
        post.trim_votecode
        post.selected = post.vote_option_ids.length
        ret = VoteOption.increment_counter(:count, post.vote_option_ids)
        unless ret == post.vote_option_ids.length
          throw ActiveRecord::RecordInvalid
        end
      else
        post.selected = 0
      end
      post.save!
    end
    true
  rescue
    false
  end

  def self.set_present(user)
    return false unless Agenda.now.present?
    state = false
    begin
      user.update!(presence: true)
      Adjustment.create!(user: user, agenda: Agenda.now, presence: true)
      state = true
    rescue
      state = false
    end
    state
  end

  def self.set_not_present(user)
    state = false
    return state if Vote.current.present? || Agenda.now.nil?
    begin
      user.update!(presence: false)
      Adjustment.create!(user: user, agenda: Agenda.now, presence: false)
      state = true
    rescue
      state = false
    end
    state
  end

  def self.set_all_not_present
    agenda = Agenda.now
    return if Vote.current.present? || agenda.nil?
    User.transaction do
      User.present.each do |u|
        u.update!(presence: false)
        Adjustment.create!(user: u, agenda: agenda, presence: false)
      end
    end
  end

  def self.set_votecode(user)
    votecode = votecode_generator
    begin
      user.update!(votecode: votecode)
      VoteMailer.votecode(user).deliver_now
      true
    rescue
      false
    end
  end

  def self.votecode_generator
    votecode = Array.new(7) { [*'0'..'9', *'a'..'z'].sample }.join
    User.with_deleted.any? { |x| x.votecode == votecode } ? votecode_generator : votecode
  end

  def self.reset(vote)
    Vote.transaction do
      vote.update!(present_users: 0, reset: true)
      vote.vote_posts.destroy_all
      vote.vote_options.update_all(count: 0)
      true
    end
  rescue
    false
  end
end
