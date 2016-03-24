require 'rails_helper'
RSpec.feature 'User update' do
  describe 'set card number' do
    it 'allows updating card number when not set' do
      user = create(:user, presence: false, card_number: nil)
      LoginPage.new.visit_page.login(user)
      new_card_number = '6122-6122-6122-6122'

      page.status_code.should eq(200)

      within('.user.status') do
        first(:linkhref, own_user_path).click
      end

      page.status_code.should eq(200)
      fill_in('user[card_number]', with: new_card_number)
      find('#user-card-number-submit').click

      page.status_code.should eq(200)
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t(:success_update))

      user.reload
      user.card_number.should eq(new_card_number)
    end
  end
end
