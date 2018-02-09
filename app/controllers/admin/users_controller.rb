# frozen_string_literal: true

# Handles administration for users, roles and sign in
class Admin::UsersController < Admin::BaseController
  authorize_resource

  def index
    @users = User.order(:id).page(params[:page])
    @users = @users.per(User.count) if params['all'].present?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      @user.send_confirmation_instructions if resend_confirmation?(@user)
      redirect_to(edit_admin_user_path(@user), notice: t('.success'))
    else
      render(:edit, status: 422)
    end
  end

  def destroy
    User.find(params[:id]).destroy!
    redirect_to(admin_users_path, notice: t('.success'))
  end

  private

  def resend_confirmation?(user)
    params.require(:user).fetch(:resend_confirmation, false) && !user.confirmed?
  end

  def user_params
    params.require(:user).permit(:card_number, :firstname, :lastname, :role)
  end
end
