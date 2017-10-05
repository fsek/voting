class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_devise_parameters, if: :devise_controller?
  before_action :set_current_user

  helper_method :alert_update, :alert_create, :alert_destroy, :can_administrate?

  rescue_from CanCan::AccessDenied do |ex|
    if current_user.nil?
      redirect_to :new_user_session, alert: ex.message
    else
      redirect_to :root, alert: ex.message
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    flash[:alert] = "Fel i formulär"
    render referring_action, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    # translate record not found -> HTTP 404
    fail ActionController::RoutingError.new 'not found'
  end

  rescue_from ActionController::RedirectBackError do
    redirect_to :root
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

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end

  def set_current_user
    User.current = current_user
  end
end
