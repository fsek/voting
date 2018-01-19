# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Set current item', as: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  describe 'PATCH #set_current' do
    it 'makes closed @sub_item current' do
      sign_in(adjuster)
      sub_item = create(:sub_item, status: :closed)

      patch(admin_current_item_path(sub_item), xhr: true)
      expect(response).to have_http_status(200)

      sub_item.reload
      expect(sub_item.current?).to be_truthy
      expect(Item.current).to eq(sub_item.item)
    end

    it 'doesnt work if there already is a current sub_item' do
      create(:sub_item, status: :current)
      sub_item = create(:sub_item, status: :closed)

      patch(admin_current_item_path(sub_item), xhr: true)
      expect(response).to have_http_status(200)

      sub_item.reload
      expect(sub_item.current?).to be_falsey
      expect(Item.current).to_not eq(sub_item.item)
    end
  end

  describe 'PATCH #set_closed' do
    it 'makes current @sub_item closed' do
      sign_in(adjuster)
      sub_item = create(:sub_item, status: :current)

      delete(admin_current_item_path(sub_item), xhr: true)
      expect(response).to have_http_status(200)

      sub_item.reload
      expect(sub_item.closed?).to be_truthy
      expect(Item.current).to_not eq(sub_item.item)
    end

    it 'doesnt work if a associated vote is open' do
      sign_in(adjuster)
      sub_item = create(:sub_item, status: :current)
      create(:vote, status: :open, sub_item: sub_item)

      delete(admin_current_item_path(sub_item), xhr: true)

      sub_item.reload
      expect(sub_item.current?).to be_truthy
    end
  end
end
