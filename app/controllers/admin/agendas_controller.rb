class Admin::AgendasController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @agenda_grid = initialize_grid(Agenda, include: :parent, order: 'sort_index')
  end

  def new
    @agenda = Agenda.new
  end

  def create
    @agenda = Agenda.new(agenda_params)

    if @agenda.save
      expire_fragment('agenda_startpage')
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
      expire_fragment('agenda_startpage')
      redirect_to edit_admin_agenda_path(@agenda), notice: alert_update(Agenda)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])

    if @agenda.destroy
      expire_fragment('agenda_startpage')
      flash[:notice] = t('agenda.deleted_ok')
    else
      flash[:alert] = @agenda.errors. full_messages_for(:destroy).to_sentence
    end

    redirect_to admin_agendas_path
  end

  def set_current
    @agenda = Agenda.find(params[:id])
    expire_fragment('agenda_startpage')
    @success = @agenda.update(status: Agenda::CURRENT)
    render
  end

  def set_closed
    @agenda = Agenda.find(params[:id])
    expire_fragment('agenda_startpage')
    @success = @agenda.update(status: Agenda::CLOSED)
    render
  end

  private

  def agenda_params
    params.require(:agenda).permit(:title, :index, :parent_id, :status,
                                   :short, :description)
  end
end
