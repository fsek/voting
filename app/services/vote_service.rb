module VoteService
  def self.user_vote(post)
    begin
      VotePost.transaction do
        post.save!
        options = VoteOption.find(post.vote_option_ids)
        options.each do |o|
          o.count += 1
          o.save!
        end
      end
      true
    rescue
      false
    end
  end

  def self.change_state(user)
    if user.present?
      user.update(presence: !user.presence)

      if user.votecode == nil
        set_votecode(user)
      end
    end
  end

  def self.set_votecode(user)
    votecode = votecode_generator
    user.update!(votecode: votecode)
    # TODO: An email with the new votecode should be sent to the user!
  end

  def self.votecode_generator
    votecode = Array.new(7) { [*'0'..'9', *'a'..'z'].sample }.join
    (User.with_deleted.any? { |x| x.votecode == votecode }) ? votecode_generator : votecode
  end
end
