# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle documents for items', as: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }
  let(:sub_item) { create(:sub_item) }

  it 'needs access' do
    post(admin_sub_item_documents_url(sub_item),
         params: { sub_item: { files: [] } })
    expect(response).to redirect_to(new_user_session_url)
  end

  describe 'create' do
    it 'correct attributes' do
      attributes = { sub_item: { files: [RequestMacro.pdf] } }
      sign_in(adjuster)

      get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
      expect(response).to have_http_status(200)

      expect do
        post(admin_sub_item_documents_url(sub_item),
             params: attributes, xhr: true)
      end.to change(ActiveStorage::Attachment, :count).by(1)

      expect(response).to have_http_status(200)
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      attributes = { sub_item: { files: [] } }

      expect do
        post(admin_sub_item_documents_url(sub_item),
             params: attributes, xhr: true)
      end.to change(ActiveStorage::Attachment, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  it 'destroy' do
    sign_in(adjuster)
    sub_item.documents.attach(RequestMacro.pdf)
    document = sub_item.documents.first
    expect(document).to_not be_nil

    get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
    expect(response).to have_http_status(200)

    expect do
      delete(admin_sub_item_document_url(sub_item, document), xhr: true)
    end.to change(ActiveStorage::Attachment, :count).by(-1)

    expect(response).to have_http_status(200)
  end
end
