# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Confirm account' do
  it 'confirms the account' do
    user = create(:user, :unconfirmed)
    page.visit(user_confirmation_url(confirmation_token: user.confirmation_token))

    expect(find('div.alert').text).to \
      include(I18n.t('devise.confirmations.confirmed'))
    user.reload
    expect(user.confirmed?).to be_truthy
  end
end
