# frozen_string_literal: true

module Admin
  class VotesController < Admin::BaseController
    load_and_authorize_resource

    def index
      @vote_status_view = VoteStatusView.new
    end

    def new
      @vote = Vote.new
      @vote.vote_options.build
    end

    def create
      @vote = Vote.new(vote_params)
      if @vote.save
        redirect_to edit_admin_vote_path(@vote), notice: alert_create(Vote)
      else
        render :new, status: 422
      end
    end

    def edit
      @vote = Vote.find(params[:id])

      redirect_to admin_votes_path, alert: t('vote.cannot_edit') if @vote.open?
    end

    def update
      @vote = Vote.find(params[:id])

      if @vote.open?
        redirect_to admin_votes_path, alert: t('vote.cannot_edit')
      elsif @vote.update(vote_params)
        redirect_to edit_admin_vote_path(@vote), notice: alert_update(Vote)
      else
        render :edit, status: 422
      end
    end

    def destroy
      Vote.find(params[:id]).destroy!

      redirect_to admin_votes_path, notice: alert_destroy(Vote)
    end

    def show
      # Let vote_status hold current open vote
      # @vote holds visited vote
      @vote = Vote.find(params[:id])
      @vote_status = VoteStatusView.new
      @audits = Audit.where(vote: @vote).includes(:user, :updater)
    end

    def refresh_count
      @vote = Vote.find(params[:id])
    end

    private

    def vote_params
      params.require(:vote).permit(:title, :choices, :agenda_id,
                                   vote_options_attributes: %i[id
                                                               title
                                                               _destroy])
    end
  end
end
