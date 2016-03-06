require 'rails_helper'
RSpec.feature 'User sign up' do
  scenario 'sign up' do
    page.visit(new_user_registration_path)
    page.fill_in 'user[firstname]', with: 'Hilbert'
    page.fill_in 'user[lastname]', with: 'Älg'
    page.fill_in 'user[email]', with: 'tfy13hal@student.lu.se'
    page.fill_in 'user[password]', with: '12345678'
    page.fill_in 'user[password_confirmation]', with: '12345678'
    find('#user-submit').click

    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
  end
end
