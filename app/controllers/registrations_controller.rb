class RegistrationsController < Devise::RegistrationsController
  # This is a subclass of the devise registrations controller,
  # hence there is very little code here :)
  protected

  # overridden
  def after_sign_up_path_for(resource)
    edit_user_path(resource)
  end
end
