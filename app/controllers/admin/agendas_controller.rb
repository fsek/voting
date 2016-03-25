class Admin::AgendasController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @agenda_grid = initialize_grid(Agenda, order: 'sort_index')
  end

  def new
    @agenda = Agenda.new
  end

  def create
    @agenda = Agenda.new(agenda_params)

    if @agenda.save
      redirect_to new_admin_agenda_path, notice: alert_create(Agenda)
    else
      render :new, status: 422
    end
  end

  def edit
    @agenda = Agenda.find(params[:id])
  end

  def update
    @agenda = Agenda.find(params[:id])

    if @agenda.update(agenda_params)
      redirect_to edit_admin_agenda_path(@agenda), notice: alert_update(Agenda)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])

    @agenda.destroy!
    redirect_to admin_agendas_path, notice: alert_destroy(Agenda)
  end

  def set_current
    @agenda = Agenda.find(params[:id])
    @success = @agenda.update(status: Agenda::CURRENT)
    render
  end

  def set_closed
    @agenda = Agenda.find(params[:id])
    @success = @agenda.update(status: Agenda::CLOSED)
    render
  end

  private

  def agenda_params
    params.require(:agenda).permit(:title, :index, :parent_id, :status)
  end
end
