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

    search_params = { search: { presence: nil } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response.body).to include('Hilbert1', 'Hilbert2')
  end

  it 'by presence' do
    sign_in(adjuster)
    create(:user, firstname: 'Hilbert', lastname: 'ÄlgHär', presence: true)
    create(:user, firstname: 'Hilbert', lastname: 'ÄlgInteHär', presence: false)

    search_params = { search: { firstname: 'Hilbert', presence: true } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response).to have_http_status(200)
    expect(response.body).to include('ÄlgHär')
    expect(response.body).to_not include('ÄlgInteHär')
  end

  it 'works correctly for full first and last name' do
    sign_in(adjuster)
    create(:user, firstname: 'Johan', lastname: 'Winther')
    search_params = { search: { 'firstname': 'Johan', 'lastname': 'Winther' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response).to have_http_status(200)
    expect(response.body).to include('Johan')
    expect(response.body).to include('Winther')
  end

  it 'does not show matches on lastname if search for in firstname' do
    sign_in(adjuster)
    create(:user, firstname: 'Johan', lastname: 'Winther')
    search_params = { search: { firstname: 'Winther' } }

    post(user_admin_search_path, params: search_params, xhr: true)
    expect(response).to have_http_status(200)
    expect(response.body).not_to include('Johan')
  end
end
