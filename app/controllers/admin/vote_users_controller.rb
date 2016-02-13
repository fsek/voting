class Admin::VoteUsersController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
    @vote_users_grid = initialize_grid(User)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_vote_users_path, notice: alert_update(User)
    else
      render :edit, status: 422
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def change_state
    @user = User.find(params[:id])

    if @user.present?
      @user.presence = !@user.presence
      @user.save!
    end

    redirect_to admin_vote_users_path
  end

  def make_all_not_present
    User.update_all(presence: false)
    redirect_to admin_vote_users_path
  end

  private

  def authorize
    authorize! :manage_voting, User
  end

  def user_params
    params.require(:user).permit(:presence)
  end

  def gen_votecode
    votecode = Array.new(7){ [*'0'..'9', *'a'..'z'].sample }.join
    (User.with_deleted.any? { |x| x.votecode == votecode }) ? gen_votecode : votecode
  end
end
