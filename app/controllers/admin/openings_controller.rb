# frozen_string_literal: true

module Admin
  # Handles opening and closing of votes
  class OpeningsController < Admin::BaseController
    authorize_resource(class: Vote)

    def create
      vote = Vote.find(params[:vote_id])

      if vote.update(status: :open)
        flash[:notice] = I18n.t('vote.made_open')
      else
        flash[:alert] = vote.errors[:status].to_sentence
      end

      redirect_back(fallback_location: admin_votes_path)
    end

    def destroy
      vote = Vote.find(params[:vote_id])
      vote.closed!

      redirect_back(fallback_location: admin_votes_path,
                    notice: t('vote.made_closed'))
    end
  end
end
