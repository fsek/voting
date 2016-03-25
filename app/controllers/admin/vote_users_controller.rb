class Admin::VoteUsersController < Admin::BaseController
  authorize_resource class: false

  def index
    @vote_status_view = VoteStatusView.new
    @vote_users_grid = initialize_grid(User, order: 'firstname')
  end

  def show
    @user = User.find(params[:id])
    @votes = Vote.with_deleted
    @audit_grid = initialize_grid(Audit.where(user_id: @user.id), include: :updater, name: 'g')
    @adjustments = @user.adjustments.rank(:row_order)
  end

  def attendance_list
    @attend_grid = initialize_grid(User.all_attended)
  end

  def present
    @user = User.find(params[:id])
    @success = VoteService.set_present(@user)
    render
  end

  def not_present
    @user = User.find(params[:id])
    @success = VoteService.set_not_present(@user)
    render
  end

  def all_not_present
    if VoteService.set_all_not_present
      flash[:notice] = t('vote_user.state.all_not_present')
    else
      flash[:alert] = t('vote_user.state.error_all_not_present')
    end
    redirect_to admin_vote_users_path
  end

  def new_votecode
    @user = User.find(params[:id])
    @success = VoteService.set_votecode(@user)
    render
  end

  def search
    @vote_users = User.card_number(search_params[:card_number])
  end

  private

  def search_params
    params.require(:vote_user).permit(:card_number)
  end
end
