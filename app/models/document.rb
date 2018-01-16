# frozen_string_literal: true

# Allows uploading a document for viewing
class Document < ApplicationRecord
  acts_as_list(scope: :sub_item)
  belongs_to(:sub_item)

  validates(:title, :pdf, presence: true)

  mount_uploader(:pdf, DocumentUploader)
  scope(:position, -> { order(:position) })

  # For caching pdf in form
  attr_accessor :pdf_cache

  def to_s
    title || id
  end

  def view
    pdf.url
  end
end
