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
      if VoteService.attends(@user)
        render(:success)
      else
        render(:error, status: 422)
      end
    end

    def destroy
      @user = User.find(params[:id])
      if VoteService.unattends(@user)
        render(:success)
      else
        render(:error, status: 422)
      end
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
