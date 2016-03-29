class StartPage
  attr_accessor :agendas, :news, :events, :notices

  def initialize(signed_in: false)
    @agendas = Agenda.index.where(parent_id: nil).includes(:children) || []
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
    @notices = get_notices(signed_in) || []
  end

  private

  def get_notices(signed_in)
    if signed_in
      Notice.sorted
    else
      Notice.publik.sorted
    end
  end
end
