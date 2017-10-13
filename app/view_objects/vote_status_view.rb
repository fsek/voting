class VoteStatusView
  attr_accessor :vote_post
  attr_reader :adjusted, :agenda, :vote

  def initialize
    @adjusted = User.present.count
    @agenda = Agenda.includes(:votes).now
    @vote = Vote.current
  end
end
