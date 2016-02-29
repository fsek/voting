class Admin::VotesController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @votes_grid = initialize_grid(Vote)
  end

  def new
    @vote = Vote.new
    @vote.vote_posts.build
  end

  def create
    @vote = Vote.new(vote_params)

    if @vote.save
      redirect_to edit_admin_vote_path(@vote), notice: alert_create(Vote)
    else
      render :new, status: 422
    end
  end

  def edit
    @vote = Vote.find(params[:id])
  end

  def update
    @vote = Vote.find(params[:id])

    if @vote.update(vote_params)
      redirect_to edit_admin_vote_path(@vote), notice: alert_update(Vote)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @vote = Vote.find(params[:id])

    @vote.destroy!
    redirect_to admin_votes_path, notice: alert_destroy(Vote)
  end

  def show
    @vote = Vote.find(params[:id])
    @grid = initialize_grid(Audit.where(vote_id: @vote.id), include: [:user, :updater])
  end

  def change_state
    @vote = Vote.find(params[:id])

    if @vote != nil
      @vote.open = !@vote.open
      @vote.save!
    end

    redirect_to admin_votes_path
  end

  private

  def authorize
    authorize! :manage, Vote
  end

  def vote_params
    params.require(:vote).permit(:title, :open, :choices,
                                 vote_options_attributes: [:id, :title, :_destroy])
  end

end
