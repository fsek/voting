class Admin::UsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @users_grid = initialize_grid(User, include: :permissions)
  end

  private

  def authorize
    authorize! :manage, User
  end
end
