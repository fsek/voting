class VoteStatusView
  attr_accessor :vote_post
  attr_reader :adjusted, :agenda, :vote

  def initialize(vote: Vote.current)
    @adjusted = User.present.count
    @agenda = Agenda.includes(:votes).current
    @vote = vote
  end

  def number_of_votes
    if @vote.closed?
      "#{@vote.vote_posts.count} / #{@vote.present_users}"
    elsif @vote.open?
      "#{@vote.vote_posts.count} / #{User.present.count}"
    end
  end
end
