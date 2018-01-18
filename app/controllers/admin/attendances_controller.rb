# frozen_string_literal: true

module Admin
  # Handles setting presence of users and displaying and exporting of
  # user attendance list
  class AttendancesController < Admin::BaseController
    authorize_resource class: false
    def index
      @users = User.all_attended
    end

    def update
      @user = User.find(params[:id])
      render(status: 422) unless (@success = VoteService.attends(@user))
    end

    def destroy
      @user = User.find(params[:id])
      render(status: 422) unless (@success = VoteService.unattends(@user))
    end

    def destroy_all
      if VoteService.unattend_all
        flash[:notice] = t('vote_user.state.all_not_present')
      else
        flash[:alert] = t('vote_user.state.error_all_not_present')
      end
      redirect_to admin_vote_users_path
    end
  end
end
