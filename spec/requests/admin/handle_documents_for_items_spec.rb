# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle documents for items', as: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }
  let(:sub_item) { create(:sub_item) }

  it 'needs access' do
    post(admin_sub_item_documents_url(sub_item),
         params: { document: { pdf: nil } })
    expect(response).to redirect_to(new_user_session_url)
  end

  describe 'create' do
    it 'correct attributes' do
      attributes = { document: { title: 'Bilaga 1',
                                 position: 1,
                                 pdf: RequestMacro.pdf } }
      sign_in(adjuster)

      get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
      expect(response).to have_http_status(200)

      expect do
        post(admin_sub_item_documents_url(sub_item),
             params: attributes, xhr: true)
      end.to change(Document, :count).by(1)

      document = Document.last
      expect(response).to have_http_status(200)

      expect(document.sub_item).to eq(sub_item)
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      attributes = { document: { pdf: nil } }

      expect do
        post(admin_sub_item_documents_url(sub_item),
             params: attributes, xhr: true)
      end.to change(Document, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    it 'correct attributes' do
      sign_in(adjuster)
      document = create(:document, sub_item: sub_item, title: 'Bilaga A')
      attributes = { document: { title: 'Bilaga C' } }
      get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
      expect(response).to have_http_status(200)

      patch(admin_sub_item_document_url(sub_item, document), params: attributes,
                                                             xhr: true)
      document.reload

      expect(response).to have_http_status(200)
      expect(document.title).to eq('Bilaga C')
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      document = create(:document, sub_item: sub_item)
      attributes = { document: { pdf: nil } }
      get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
      expect(response).to have_http_status(200)

      patch(admin_sub_item_document_url(sub_item, document), params: attributes,
                                                             xhr: true)
      document.reload

      expect(response).to have_http_status(422)
      expect(document.pdf).to be_present
    end
  end

  it 'destroy' do
    sign_in(adjuster)
    document = create(:document, sub_item: sub_item)
    get(edit_admin_item_sub_item_url(sub_item.item, sub_item))
    expect(response).to have_http_status(200)

    expect do
      delete(admin_sub_item_document_url(sub_item, document))
    end.to change(Document, :count).by(-1)

    expect(response).to \
      redirect_to(edit_admin_item_sub_item_url(sub_item.item, sub_item))
  end
end
