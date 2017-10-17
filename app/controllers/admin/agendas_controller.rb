# frozen_string_literal: true

module Admin
  # Handles creating and updating the agenda
  class AgendasController < Admin::BaseController
    authorize_resource

    def index
      @agendas = Agenda.order(:sort_index).includes(:parent).page(params[:page])
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
        redirect_to edit_admin_agenda_path(@agenda),
                    notice: alert_update(Agenda)
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

    private

    def agenda_params
      params.require(:agenda).permit(:title, :index, :parent_id,
                                     :status, :short, :description)
    end
  end
end
