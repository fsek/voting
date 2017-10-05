class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @users_grid = initialize_grid(User)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to(edit_admin_user_path(@user), notice: alert_update(User))
    else
      render :edit, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:card_number, :firstname, :lastname, :role)
  end
end
