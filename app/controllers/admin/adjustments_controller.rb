# frozen_string_literal: true

class Admin::AdjustmentsController < Admin::BaseController
  authorize_resource

  def new
    @user = User.find(params[:user_id])
    @adjustment = Adjustment.new(user: @user)
  end

  def create
    @adjustment = Adjustment.new(adjustment_params)
    if @adjustment.save
      redirect_to admin_vote_user_path(@adjustment.user),
                  notice: t('.success')
    else
      render :new, status: 422
    end
  end

  def edit
    @adjustment = Adjustment.find(params[:id])
  end

  def update
    @adjustment = Adjustment.find(params[:id])
    user = @adjustment.user

    if @adjustment.update(adjustment_params)
      redirect_to edit_admin_adjustment_path(@adjustment), notice: t('.success')
    else
      @adjustment.user = user
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
    @id = ActionView::RecordIdentifier.dom_id(adjustment)
    adjustment.destroy!
  end

  def index
    @vote_status_view = VoteStatusView.new
  end

  private

  def adjustment_params
    params.require(:adjustment).permit(:sub_item_id, :presence, :user_id)
  end

  def order_params
    params.require(:adjustment).permit(:row_order_position)
  end
end
