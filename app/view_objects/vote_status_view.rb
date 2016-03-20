class VoteStatusView
  attr_reader :adjusted, :agenda, :vote

  def initialize
    @adjusted = User.present.count
    @agenda = Agenda.current
    @vote = Vote.current
  end
end
