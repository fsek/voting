class StartPage
  attr_accessor :agendas, :news

  def initialize
    @agendas = Agenda.index.where(parent_id: nil).includes(:children) || []
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
  end
end
