module VoteService
  def self.user_vote(post)
    begin
      VotePost.transaction do
        if post.vote_option_ids.present?
          post.selected = post.vote_option_ids.length
          options = VoteOption.find(post.vote_option_ids)
          options.each do |o|
            o.lock!
            o.count += 1
            o.save!
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
  end

  def self.set_present(user)
    state = false
    if !Agenda.current.nil?
      begin
        user.update!(presence: true)
        Adjustment.create!(user: user, agenda: Agenda.current, presence: true)
        state = true
      rescue
        state = false
      end
    end
    state
  end

  def self.set_not_present(user)
    state = false
    if Vote.current.nil? && !Agenda.current.nil?
      begin
        user.update!(presence: false)
        Adjustment.create!(user: user, agenda: Agenda.current, presence: false)
        state = true
      rescue
        state = false
      end
    end
    state
  end

  def self.set_all_not_present
    agenda = Agenda.current
    if Vote.current.nil? && !agenda.nil?
      User.transaction do
        User.present.each do |u|
          u.update!(presence: false)
          Adjustment.create!(user: u, agenda: agenda, presence: false)
        end
      end
      true
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
    (User.with_deleted.any? { |x| x.votecode == votecode }) ? votecode_generator : votecode
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
