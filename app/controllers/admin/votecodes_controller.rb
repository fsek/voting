# frozen_string_literal: true

module Admin
  # Handles sending new votecodes to users
  class VotecodesController < Admin::BaseController
    authorize_resource(class: false)

    def update
      @user = User.find(params[:id])
      @success = VoteService.set_votecode(@user)
    end
  end
end
