# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle sub items', as: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }
  let(:item) { create(:item) }

  it 'needs access' do
    get(new_admin_item_sub_item_url(item))
    expect(response).to redirect_to(new_user_session_url)
  end

  describe 'create' do
    it 'correct attributes' do
      attributes = { title: 'Motion 10', position: 10, type: :decision }
      sign_in(adjuster)

      get(new_admin_item_sub_item_url(item))
      expect(response).to have_http_status(200)

      expect do
        post(admin_item_sub_items_url, params: { sub_item: attributes })
      end.to change(SubItem, :count).by(1)

      sub_item = SubItem.last
      expect(response).to redirect_to(edit_admin_item_url(item))

      expect(sub_item.item).to eq(item)
      expect(sub_item.position).to eq(10)

      follow_redirect!
      expect(response).to have_http_status(200)
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      attributes = { position: 10, type: :election }

      expect do
        post(admin_items_url, params: { item: attributes })
      end.to change(Item, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    it 'correct attributes' do
      sign_in(adjuster)
      item = create(:item, type: :announcement)
      attributes = { item: { type: :election } }
      get(edit_admin_item_url(item))
      expect(response).to have_http_status(200)

      patch(admin_item_url(item), params: attributes)
      item.reload

      expect(response).to redirect_to(edit_admin_item_url(item))
      expect(item.election?).to be_truthy
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      item = create(:item, title: 'NotChanged')
      attributes = { item: { title: '' } }

      patch(admin_item_url(item), params: attributes)
      item.reload

      expect(response).to have_http_status(422)
      expect(item.title).to eq('NotChanged')
    end
  end

  it 'destroy' do
    sign_in(adjuster)
    item = create(:item)

    expect do
      delete(admin_item_url(item))
    end.to change(Item, :count).by(-1)

    expect(response).to redirect_to(admin_items_url)
  end
end
