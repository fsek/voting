class Admin::VoteUsersController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
    @vote_users_grid = initialize_grid(User)
  end

  def show
    @user = User.find(params[:id])
    @votes = Vote.with_deleted
    @grid = initialize_grid(Audit.where(user_id: @user.id), include: :updater)
  end

  def present
    @user = User.find(params[:id])
    if VoteService.set_present(@user)
      redirect_to admin_vote_users_path,
                  notice: t('vote_user.state.made_present', u: @user.to_s)
    else
      redirect_to admin_vote_users_path,
                  alert: t('vote_user.state.error_present', u: @user.to_s)
    end
  end

  def not_present
    @user = User.find(params[:id])
    if VoteService.set_not_present(@user)
      redirect_to admin_vote_users_path,
                  notice: t('vote_user.state.made_not_present', u: @user.to_s)
    else
      redirect_to admin_vote_users_path,
                  alert: t('vote_user.state.error_not_present', u: @user.to_s)
    end
  end

  def all_not_present
    if VoteService.set_all_not_present
      redirect_to admin_vote_users_path, notice: t('vote_user.state.all_not_present')
    else
      redirect_to admin_vote_users_path, alert: t('vote_user.state.error_all_not_present')
    end
  end

  def new_votecode
    @user = User.find(params[:id])
    if VoteService.set_votecode(@user)
      redirect_to admin_vote_users_path,
                  notice: t('vote_user.votecode_success', u: @user.to_s)
    else
      render :edit, status: 422
    end
  end

  private

  def authorize
    authorize! :manage_voting, User
  end
end
