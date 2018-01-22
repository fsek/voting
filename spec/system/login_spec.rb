# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'User sign in' do
  let(:user) { create(:user) }

  it 'sign in correct credentials' do
    page.visit(root_path)
    within('nav.navbar') do
      first(:linkhref, new_user_session_path).click
    end
    page.fill_in 'user_email', with: user.email
    page.fill_in 'user_password', with: '12345678'
    page.click_button I18n.t('devise.sign_in')
    expect(page).to have_css('div.alert')
    expect(find('div.alert').text).to \
      include(I18n.t('devise.sessions.signed_in'))
  end

  it 'sign in incorrect password' do
    page.visit(new_user_session_path)
    page.fill_in 'user_email', with: user.email
    page.fill_in 'user_password', with: 'wrong'
    page.click_button I18n.t('devise.sign_in')
    expect(page).to have_css('div.alert')
    expect(find('div.alert').text).to include(I18n.t('devise.failure.invalid'))
  end

  it 'sign in non existing email' do
    page.visit(new_user_session_path)
    page.fill_in 'user_email', with: 'not-existing@email.com'
    page.fill_in 'user_password', with: 'wrong'
    page.click_button I18n.t('devise.sign_in')
    expect(page).to have_css('div.alert')
    expect(find('div.alert').text).to \
      include(I18n.t('devise.failure.user.not_found_in_database'))
  end
end
