# frozen_string_literal: true

class UsersController < ApplicationController
  authorize_resource

  def show; end

  def update
    if UserService.set_card_number(current_user, user_params[:card_number])
      redirect_to(user_path, notice: t('.success'))
    else
      render(:show, status: 422)
    end
  end

  def account; end

  def update_account
    if current_user.update_with_password(account_params)
      redirect_to(account_user_path, notice: t('.success'))
    else
      flash[:alert] = t('.password_required')
      render(:account, status: 422)
    end
  end

  def password; end

  def update_password
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      redirect_to(password_user_path, notice: t('.success'))
    else
      flash[:alert] = t('.password_required')
      render(:password, status: 422)
    end
  end

  private

  def user_params
    params.require(:user).permit(:card_number)
  end

  def account_params
    params.require(:user).permit(:email, :current_password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation,
                                 :current_password)
  end
end
