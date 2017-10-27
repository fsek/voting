# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_devise_parameters
  before_action :set_current_user
  before_action :store_current_location

  helper_method :alert_update, :alert_create, :alert_destroy, :can_administrate?

  rescue_from CanCan::AccessDenied do |ex|
    if current_user.nil?
      redirect_to :new_user_session, alert: ex.message
    else
      redirect_to :root, alert: ex.message
    end
  end

  def model_name(model)
    model.model_name.human if model.instance_of?(Class)
  end

  def alert_update(resource)
    %(#{model_name(resource)} #{I18n.t(:success_update)}.)
  end

  def alert_create(resource)
    %(#{model_name(resource)} #{I18n.t(:success_create)}.)
  end

  def alert_destroy(resource)
    %(#{model_name(resource)} #{I18n.t(:success_destroy)}.)
  end

  protected

  def configure_permitted_devise_parameters
    return unless devise_controller?
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:email, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:password, :password_confirmation, :current_password)
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def current_admin_ability
    @current_admin_ability ||= AdminAbility.new(current_user)
  end

  def can_administrate?(*args)
    current_admin_ability.can?(*args)
  end

  def set_current_user
    User.current = current_user
  end

  def store_current_location
    return if devise_controller? || !request.format.html?
    store_location_for(:user, request.url)
  end
end
