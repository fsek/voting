# frozen_string_literal: true

module Admin
  class SearchesController < Admin::BaseController
    authorize_resource(class: false)

    def card
      card_number = params.require(:search).permit(:card_number)
      @vote_user = User.card_number(card_number.fetch(:card_number, ''))
    end

    def user
      @vote_users = User.search(user_params).where(presence: presence)
    end

    private

    def presence
      res = params.require(:search).fetch(:presence, '')
      return [true, false] if res.blank?
      res
    end

    def user_params
      params.require(:search).permit(:firstname, :lastname, :card_number)
            .reject { |_, v| v.blank? }
    end
  end
end
