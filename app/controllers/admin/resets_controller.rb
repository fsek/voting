# frozen_string_literal: true

module Admin
  # Handles resets of votes
  class ResetsController < Admin::BaseController
    authorize_resource(class: Vote)

    def create
      vote = Vote.find(params[:vote_id])

      if vote.open?
        flash[:alert] = I18n.t('vote.cannot_reset')
      elsif VoteService.reset(vote)
        flash[:notice] = I18n.t('vote.reset_ok')
      else
        flash[:alert] = I18n.t('vote.reset_failed')
      end

      redirect_to admin_vote_path(vote)
    end
  end
end
