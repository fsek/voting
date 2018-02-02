# frozen_string_literal: true

require 'rails_helper'

RSpec.describe("Handle adjustments manually", type: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  it 'visits index' do
    sign_in(adjuster)
    sub_item = create(:sub_item, status: :current)
    # vote = create(:vote, status: :open, sub_item: sub_item)
    get(admin_adjustments_path)
    expect(response).to have_http_status(200)
  end

  describe 'create new adjustments' do
    it 'valid parameters' do
      sign_in(adjuster)
      user = create(:user)
      sub_item = create(:sub_item)
      get(new_admin_adjustment_path(user_id: user.id))
      expect(response).to have_http_status(200)

      attributes = { sub_item_id: sub_item.to_param,
                     user_id: user.to_param,
                     presence: true }
      expect do
        post(admin_adjustments_path, params: { adjustment: attributes },
                                     xhr: true)
      end.to change(Adjustment, :count).by(1)
      expect(response).to redirect_to(admin_vote_user_path(user))
    end

    it 'invalid parameters' do
      sign_in(adjuster)
      user = create(:user)
      attributes = { sub_item_id: nil,
                     user_id: user.to_param,
                     presence: true }
      expect do
        post(admin_adjustments_path, params: { adjustment: attributes },
                                     xhr: true)
      end.to change(Adjustment, :count).by(0)
      expect(response).to have_http_status(422)
    end
  end

  describe 'updates adjustments' do
    it 'valid parameters' do
      sign_in(adjuster)
      adjustment = create(:adjustment, presence: true)
      get(edit_admin_adjustment_path(adjustment))
      expect(response).to have_http_status(200)

      attributes = { presence: false }
      patch(admin_adjustment_path(adjustment),
            params: { adjustment: attributes }, xhr: true)
      expect(response).to redirect_to(edit_admin_adjustment_path(adjustment))
      adjustment.reload
      expect(adjustment.presence).to be_falsey
    end

    it 'invalid parameters' do
      sign_in(adjuster)
      adjustment = create(:adjustment, presence: true)
      attributes = { user_id: nil }
      patch(admin_adjustment_path(adjustment),
            params: { adjustment: attributes }, xhr: true)
      expect(response).to have_http_status(422)
      adjustment.reload
      expect(adjustment.presence).to be_truthy
    end
  end

  it 'destroys adjustment' do
    sign_in(adjuster)
    adjustment = create(:adjustment)

    expect do
      delete(admin_adjustment_path(adjustment), xhr: true)
    end.to change(Adjustment, :count).by(-1)
    expect(response).to have_http_status(200)
  end

  it 'updates ordering of adjustments' do
    sign_in(adjuster)
    user = create(:user)
    a1 = create(:adjustment, user: user)
    a2 = create(:adjustment, user: user)
    a3 = create(:adjustment, user: user)
    attributes = { id: a3.to_param, adjustment: { position: 1 } }
    patch(update_order_admin_adjustments_path, params: attributes, xhr: true)
    expect(response).to have_http_status(200)

    user.reload
    expect(user.adjustments.map(&:id)).to eq([a3, a1, a2].map(&:id))
  end
end
