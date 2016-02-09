class Admin::PermissionUsersController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @perm_user_grid = initialize_grid(PermissionUser, include: [:user, :permission])
  end

  def new
    @perm_user = PermissionUser.new
  end

  def create
    @perm_user = PermissionUser.new(permission_user_params)

    if @perm_user.save
      redirect_to admin_permission_users_path, notice: alert_create(PermissionUser)
    else
      render :new, status: 422
    end
  end

  def destroy
    @perm_user = PermissionUser.find(params[:id])
    @perm_user.destroy!
    redirect_to admin_permission_users_path, notice: alert_destroy(PermissionUser)
  end


  private

  def authorize
    authorize!(:manage, PermissionUser)
  end

  def permission_user_params
    params.require(:permission_user).permit(:user_id, :permission_id)
  end
end
