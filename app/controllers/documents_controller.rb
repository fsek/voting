# frozen_string_literal: true

class DocumentsController < ApplicationController
  authorize_resource

  def show
    document = Document.find(params[:id])
    if document.view
      redirect_to(document.view)
    else
      redirect_back(fallback_path: root_path, alert: t('.not_found'))
    end
  end
end
