class Admin::DocumentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @documents = Document.order(:title).includes(:user, :agenda)
    @documents = @documents.page(params[:page])
  end

  def edit
    @document = Document.find(params[:id])
    @categories = Document.categories
  end

  def new
    @document = Document.new
    @categories = Document.categories
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    @categories = Document.categories

    if @document.save
      redirect_to edit_admin_document_path(@document),
                  notice: alert_create(Document)
    else
      render :new, status: 422
    end
  end

  def update
    @document = Document.find(params[:id])
    @document.user = current_user
    @categories = Document.categories

    if @document.update(document_params)
      redirect_to edit_admin_document_path(@document),
                  notice: alert_update(Document)
    else
      render :edit, status: 422
    end
  end

  def destroy
    Document.find(params[:id]).destroy!
    redirect_to admin_documents_path, notice: alert_destroy(Document)
  end

  private

  def document_params
    params.require(:document).permit(:title, :pdf, :public,
                                     :category, :agenda_id)
  end
end
