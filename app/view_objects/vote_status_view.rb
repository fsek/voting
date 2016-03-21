class VoteStatusView
  attr_accessor :vote_post
  attr_reader :adjusted, :agenda, :vote

  def initialize(vote: Vote.current)
    @adjusted = User.present.count
    @agenda = Agenda.includes(:votes).current
    @vote = vote
  end
end
