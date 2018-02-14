# frozen_string_literal: true

module Admin
  class VotesController < Admin::BaseController
    authorize_resource

    def index
      @votes = Vote.includes(:sub_item).order(:sub_item_id, :position)
      @vote_status_view = VoteStatusView.new
    end

    def new
      @vote = Vote.new
      @vote.vote_options.build
      @sub_items = SubItem.full_order
    end

    def create
      @vote = Vote.new(vote_params)
      @sub_items = SubItem.full_order
      if @vote.save
        redirect_to edit_admin_vote_path(@vote), notice: t('.success')
      else
        render :new, status: 422
      end
    end

    def edit
      @vote = Vote.find(params[:id])
      @sub_items = SubItem.full_order

      redirect_to admin_votes_path, alert: t('.cannot_edit') if @vote.open?
    end

    def update
      @vote = Vote.find(params[:id])
      @sub_items = SubItem.full_order

      if @vote.open?
        redirect_to admin_votes_path, alert: t('.cannot_edit')
      elsif @vote.update(vote_params)
        redirect_to edit_admin_vote_path(@vote), notice: t('.success')
      else
        render :edit, status: 422
      end
    end

    def destroy
      Vote.find(params[:id]).destroy!

      redirect_to admin_votes_path, notice: t('.success')
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
      params.require(:vote).permit(:title, :choices, :sub_item_id, :position,
                                   vote_options_attributes: %i[id
                                                               title
                                                               _destroy])
    end
  end
end
