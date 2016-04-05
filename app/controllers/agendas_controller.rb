class AgendasController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @agenda = Agenda.includes(:documents).includes(children: :parent).find(params[:id])
    @current_agenda = Agenda.current
  end
end
