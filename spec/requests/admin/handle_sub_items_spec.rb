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
      attributes = { title: 'Motion 10', position: 10 }
      sign_in(adjuster)

      get(new_admin_item_sub_item_url(item))
      expect(response).to have_http_status(200)

      expect do
        post(admin_item_sub_items_url(item), params: { sub_item: attributes })
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
      attributes = { position: 10 }

      expect do
        post(admin_item_sub_items_url(item), params: { sub_item: attributes })
      end.to change(SubItem, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    it 'correct attributes' do
      sign_in(adjuster)
      sub_item = create(:sub_item, item: item, title: 'Motion om blaa')
      attributes = { sub_item: { title: 'Proposition om blaa' } }
      get(edit_admin_item_url(sub_item.item))
      expect(response).to have_http_status(200)

      patch(admin_item_sub_item_url(item, sub_item),
            params: attributes)
      sub_item.reload

      expect(response).to redirect_to(edit_admin_item_url(item))
      expect(sub_item.title).to eq('Proposition om blaa')
    end

    it 'incorrect attributes' do
      sign_in(adjuster)
      sub_item = create(:sub_item, item: item, title: 'NotChanged')
      attributes = { sub_item: { title: '' } }

      patch(admin_item_sub_item_url(item, sub_item),
            params: attributes)
      sub_item.reload

      expect(response).to have_http_status(422)
      expect(sub_item.title).to eq('NotChanged')
    end
  end

  it 'destroy' do
    sign_in(adjuster)
    sub_item = create(:sub_item, item: item)

    expect do
      delete(admin_item_sub_item_url(item, sub_item))
    end.to change(SubItem, :count).by(-1)

    expect(response).to redirect_to(edit_admin_item_url(item))
  end
end
