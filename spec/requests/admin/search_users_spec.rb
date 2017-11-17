# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Search for users', type: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  it 'searches by first name' do
    sign_in(adjuster)
    create(:user, firstname: 'Hilbert', lastname: 'Älg')

    search_params = { search: { firstname: 'Hilbe' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response).to have_http_status(200)
  end
end
