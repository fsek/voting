# frozen_string_literal: true

module Admin
  # Handles vote users displaying
  class VoteUsersController < Admin::BaseController
    authorize_resource class: false

    def index
      @vote_status_view = VoteStatusView.new
      @vote_users = User.order(:firstname, :lastname).page(params[:page])
    end

    def show
      @user = User.find(params[:id])
      @votes = Vote.with_deleted
      @adjustments = @user.adjustments
                          .includes(agenda: :parent)
                          .rank(:row_order)
      @audits = @user.audits.includes(:updater)
    end

    def search
      @vote_users = User.card_number(search_params[:card_number])
    end

    private

    def search_params
      params.require(:vote_user).permit(:card_number)
    end
  end
end
