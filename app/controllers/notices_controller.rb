class NoticesController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    @notice_grid = initialize_grid(@notices)
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def new
    @notice = Notice.new
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def create
    @notice = Notice.new(notice_params)
    if @notice.save
      redirect_to notice_path(@notice), notice: alert_create(Notice)
    else
      render :new, status: 422
    end
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update(notice_params)
      redirect_to notice_path(@notice), notice: alert_update(Notice)
    else
      render :edit, status: 422
    end
  end

  def destroy
    notice = Notice.find(params[:id])

    notice.destroy!
    redirect_to notices_url, notice: alert_destroy(Notice)
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :description,
                                   :public, :d_publish, :d_remove,
                                   :sort)
  end
end
