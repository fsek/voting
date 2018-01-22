# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'User sign up' do
  it 'sign up' do
    page.visit(root_path)
    within('nav.navbar') do
      first(:linkhref, new_user_registration_path).click
    end
    page.fill_in 'user[firstname]', with: 'Hilbert'
    page.fill_in 'user[lastname]', with: 'Älg'
    page.fill_in 'user[email]', with: 'tfy13hal@student.lu.se'
    page.fill_in 'user[password]', with: '12345678'
    page.fill_in 'user[password_confirmation]', with: '12345678'
    find('#user-submit').click

    expect(page).to have_css('div.alert')
    expect(find('div.alert').text).to \
      include(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
  end
end
