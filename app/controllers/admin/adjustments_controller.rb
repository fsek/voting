class Admin::AdjustmentsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

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

  def destroy
    adjustment = Adjustment.find(params[:id])
    user = adjustment.user
    adjustment.destroy!

    redirect_to admin_vote_user_path(user), notice: alert_destroy(Adjustment)
  end

  private

  def authorize
    authorize! :manage, Adjustment
  end

  def adjustment_params
    params.require(:adjustment).permit(:agenda_id, :presence, :user_id)
  end
end
