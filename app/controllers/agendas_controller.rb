class AgendasController < ApplicationController
  load_and_authorize_resource

  def index
    @agendas = Agenda.index.where(parent_id: nil).includes(:children)
  end

  def show
    @agenda = Agenda.includes(:documents).includes(children: :parent).find(params[:id])
    @current_agenda = Agenda.current
  end
end
