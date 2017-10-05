class Admin::AdjustmentsController < Admin::BaseController
  load_and_authorize_resource

  def new
    @adjustment = Adjustment.new(user_id: params[:user_id])
  end

  def create
    @adjustment = Adjustment.new(adjustment_params)
    if @adjustment.save
      redirect_to admin_vote_user_path(@adjustment.user_id), notice: alert_update(Adjustment)
    else
      render :new, status: 422
    end
  end

  def edit
    @adjustment = Adjustment.find(params[:id])
  end

  def update
    @adjustment = Adjustment.find(params[:id])

    if @adjustment.update(adjustment_params)
      redirect_to edit_admin_adjustment_path(@adjustment), notice: alert_update(Adjustment)
    else
      render :edit, status: 422
    end
  end

  def update_row_order
    adjustment = Adjustment.find(params[:id])

    if adjustment.update(order_params)
      render json: nil, status: :ok
    else
      render json: nil, status: :error
    end
  end

  def destroy
    adjustment = Adjustment.find(params[:id])
    user = adjustment.user
    adjustment.destroy!

    render json: nil, status: :ok
  end

  def index
    @vote_status_view = VoteStatusView.new
  end

  private

  def adjustment_params
    params.require(:adjustment).permit(:agenda_id, :presence, :user_id)
  end

  def order_params
    params.require(:adjustment).permit(:row_order_position)
  end
end
