# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Search for users', type: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  it 'finds a user' do
    sign_in(adjuster)
    create(:user, firstname: 'Hilbert1', lastname: 'Älg')
    create(:user, firstname: 'Hilbert2', lastname: 'Älg')

    search_params = { search: { firstname: 'Hilbert1' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response.body).to include('Hilbert1')
  end

  it 'does not find any users' do
    sign_in(adjuster)
    create(:user, firstname: 'Hilbert1', lastname: 'Älg')
    create(:user, firstname: 'Hilbert2', lastname: 'Älg')

    search_params = { search: { firstname: 'Klas' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response.body).to include(t('admin.searches.no_results'))
  end

  it 'finds all users if empty' do
    sign_in(adjuster)
    create(:user, firstname: 'Hilbert1', lastname: 'Älg')
    create(:user, firstname: 'Hilbert2', lastname: 'Älg')

    search_params = { search: { firstname: '' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response.body).to include('Hilbert1', 'Hilbert2')
  end
end
