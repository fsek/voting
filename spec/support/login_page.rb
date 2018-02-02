# frozen_string_literal: true

# Used for signing in in system specs
class LoginPage
  include Capybara::DSL

  def visit_page
    visit '/logga-in'
    self
  end

  def login(user)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '12345678'
    click_button I18n.t('devise.sign_in')
  end
end
