class VoteStatusView
  attr_accessor :vote_post
  attr_reader :adjusted, :agenda, :vote

  def initialize
    @adjusted = User.present.count
    @agenda = Agenda.includes(:votes).current
    @vote = Vote.current
  end
end
