# frozen_string_literal: true

module Admin
  class SearchesController < Admin::BaseController
    authorize_resource(class: false)

    def card
      @vote_users = User.card_number(card_params)
    end

    def user
      @vote_users = User.search(user_params).where(presence: presence)
    end

    private

    def card_params
      params.require(:search).permit(:card_number).fetch(:card_number, '')
    end

    def presence
      params.require(:search).fetch(:presence, false)
    end

    def user_params
      params.require(:search).permit(:firstname, :lastname)
            .reject { |_, v| v.blank? }
    end
  end
end
