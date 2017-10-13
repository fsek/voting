# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
    @tab ||= params[:tab].present? ? params[:tab] : :profile
  end

  def update
    @tab = :profile
    if UserService.set_card_number(current_user, user_params[:card_number])
      flash[:notice] = alert_update(User)
      render :edit
    else
      render :edit, status: 422
    end
  end

  def update_account
    @tab = :account
    if current_user.update_with_password(account_params)
      flash[:notice] = t('user.account_updated')
      render :edit
    else
      flash[:alert] = t('user.password_required')
      render :edit, status: 422
    end
  end

  def update_password
    @tab = :password
    if current_user.update_with_password(password_params)
      flash[:notice] = t('user.password_updated')
      bypass_sign_in(current_user)
      render :edit
    else
      flash[:alert] = t('user.password_required_update')
      render :edit, status: 422
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
