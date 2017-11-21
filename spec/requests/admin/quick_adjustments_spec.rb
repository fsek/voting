# frozen_string_literal: true

require 'rails_helper'

RSpec.describe("Allows quick adjustment of users", type: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  it 'view quick adjustment page and find a user' do
    sign_in(adjuster)
    create(:user, presence: false, card_number: '1234-1234-1234-1234',
                  firstname: 'Correct user!')
    attributes = { search: { card_number: '1234-1234-1234-1234' } }

    get(admin_adjustments_path)
    expect(response).to have_http_status(200)

    post(card_admin_search_path, params: attributes, xhr: true)
    expect(response).to have_http_status(200)
    expect(response.body).to include('Correct user!')

    non_existing = { search: { card_number: '2345-2345-2345-2345' } }
    post(card_admin_search_path, params: non_existing, xhr: true)
    expect(response).to have_http_status(200)
    expect(response.body).to include(t('admin.searches.no_results'))
  end
end
