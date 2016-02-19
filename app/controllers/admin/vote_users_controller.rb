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
    @audit_grid = initialize_grid(@user.audits, name: 'g1')
    @assoc_grid = initialize_grid(VotePost.includes(:audits).where(user_id: @user.id), name: 'g2')
  end

  def change_state
    VoteService.change_state(User.find(params[:id]))
    redirect_to admin_vote_users_path
  end

  def make_all_not_present
    User.update_all(presence: false)
    redirect_to admin_vote_users_path
  end

  def new_votecode
    VoteService.set_votecode(User.find(params[:id]))
    redirect_to admin_vote_users_path
  end

  private

  def authorize
    authorize! :manage_voting, User
  end

  def user_params
    params.require(:user).permit(:presence)
  end
end
