class Admin::VotesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @vote_status_view = VoteStatusView.new
    @votes_grid = initialize_grid(Vote, include: :agenda, order: 'agendas.sort_index')
  end

  def new
    @vote = Vote.new
    @vote.vote_options.build
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

    if @vote.open?
      redirect_to admin_votes_path, alert: t('vote.cannot_edit')
    end
  end

  def update
    @vote = Vote.find(params[:id])

    if @vote.open?
      redirect_to admin_votes_path, alert: t('vote.cannot_edit')
    elsif @vote.update(vote_params)
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
    # Let vote_status hold current open vote
    # @vote holds visited vote
    @vote = Vote.find(params[:id])
    @vote_status = VoteStatusView.new
    @audit_grid = initialize_grid(Audit.where(vote_id: @vote.id),
                                  include: [:user, :updater],
                                  order: 'created_at',
                                  order_direction: 'desc')
  end

  def open
    vote = Vote.find(params[:id])

    if vote.update(status: Vote::OPEN)
      flash[:notice] = I18n.t('vote.made_open')
    else
      flash[:alert] = vote.errors[:status].to_sentence
    end

    redirect_to redirect_path(vote, params[:route])
  end

  def close
    vote = Vote.find(params[:id])
    vote.update!(status: Vote::CLOSED)

    flash[:notice] = I18n.t('vote.made_closed')

    redirect_to redirect_path(vote, params[:route])
  end

  def refresh
    @vote_status_view = VoteStatusView.new
    render
  end

  def reset
    vote = Vote.find(params[:id])

    if vote.open?
      flash[:alert] = I18n.t('vote.cannot_reset')
    elsif VoteService.reset(vote)
      flash[:notice] = I18n.t('vote.reset_ok')
    else
      flash[:alert] = I18n.t('vote.reset_failed')
    end

    redirect_to admin_vote_path(vote)
  end

  def refresh_count
    @vote = Vote.find(params[:id])
  end

  private

  def vote_params
    params.require(:vote).permit(:title, :choices, :agenda_id,
                                 vote_options_attributes: [:id, :title, :_destroy])
  end

  def redirect_path(vote, route)
    if route == 'show'
      admin_vote_path(vote)
    else
      admin_votes_path
    end
  end
end
