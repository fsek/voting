class Admin::VoteUsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @vote_users_grid = initialize_grid(VoteUser)
  end

  def new
    @vote_user = VoteUser.new
    @vote_user.votecode = gen_votecode
  end

  def create
    @vote_user = VoteUser.new(vote_user_params)

    if @vote_user.save
      redirect_to new_admin_vote_user_path, notice: alert_create(VoteUser)
    else
      render :new, status: 422
    end
  end

  def edit
    @vote_user = VoteUser.find(params[:id])
  end

  def update
    @vote_user = VoteUser.find(params[:id])

    if @vote_user.update(vote_user_params)
      redirect_to admin_vote_users_path, notice: alert_update(VoteUser)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @vote_user = VoteUser.find(params[:id])

    @vote_user.destroy!
    redirect_to admin_vote_users_path, notice: alert_destroy(VoteUser)
  end

  def show
    @vote_user = VoteUser.find(params[:id])
  end

  def change_state
    @vote_user = VoteUser.find(params[:id])

    if @vote_user != nil
      @vote_user.present = !@vote_user.present
      @vote_user.save
    end
    
    redirect_to admin_vote_users_path
  end

  def make_all_not_present
    VoteUser.update_all(present: false)
    redirect_to admin_vote_users_path
  end

  private

  def authorize
    authorize! :manage, VoteUser
  end

  def vote_user_params
    params.require(:vote_user).permit(:id, :name, :votecode, :present)
  end

  def gen_votecode
      votecode = Array.new(7){[*'0'..'9', *'a'..'z'].sample}.join
      (VoteUser.any? {|x| x.votecode == votecode}) ? gen_votecode : votecode
  end
end