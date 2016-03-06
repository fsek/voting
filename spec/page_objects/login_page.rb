class LoginPage
  include Capybara::DSL

  def visit_page
    visit '/logga_in'
    self
  end

  def login(user)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '12345678'
    click_button I18n.t('devise.sign_in')
  end
end
