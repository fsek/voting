class StartPage
  attr_accessor :agendas, :news, :events, :notices

  def initialize(member: false)
    @agendas = Agenda.index.where(parent_id: nil) || []
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
    @notices = get_notices(member) || []
  end

  private

  def get_notices(member)
    if member
      Notice.published
    else
      Notice.publik.published
    end
  end
end
