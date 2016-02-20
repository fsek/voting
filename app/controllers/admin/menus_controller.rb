# encoding:UTF-8
class Admin::MenusController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize

  def index
    @menu_grid = initialize_grid(Menu)
  end

  def new
    @menu = Menu.new
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      expire_fragment('main_menu')
      redirect_to edit_admin_menu_path(@menu), notice: alert_create(Menu)
    else
      render :new, status: 422
    end
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update(menu_params)
      expire_fragment('main_menu')
      redirect_to edit_admin_menu_path(@menu), notice: alert_update(Menu)
    else
      render :edit, status: 422
    end
  end

  def destroy
    menu = Menu.find(params[:id])
    menu.destroy!
    expire_fragment('main_menu')
    redirect_to admin_menus_url, notice: alert_destroy(Menu)
  end

  private

  def authorize
    authorize!(:modify, Menu)
  end

  def menu_params
    params.require(:menu).permit(:location, :index, :link,
                                 :name, :visible, :turbolinks, :blank_p)
  end
end
