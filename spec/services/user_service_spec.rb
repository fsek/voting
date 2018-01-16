# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserService do
  describe 'set_card_number' do
    it 'sets number if none present already' do
      user = create(:user, card_number: nil)
      card_number = '6122-6122-6122-6122'

      result = UserService.set_card_number(user, card_number)

      user.reload
      result.should be_truthy
      user.card_number.should eq(card_number)
    end

    it 'returns error if card_number already set' do
      old_card_number = '6211-6211-6211-6211'
      card_number = '6122-6122-6122-6122'
      user = create(:user, card_number: old_card_number)

      result = UserService.set_card_number(user, card_number)

      user.reload
      result.should be_falsey
      user.card_number.should eq(old_card_number)
      user.errors[:card_number].should include(I18n.t('user.card_number_already_set'))
    end

    it 'returns other error if card_number is invalid' do
      invalid_card_number = 'abcd6122'
      user = create(:user, card_number: nil)

      result = UserService.set_card_number(user, invalid_card_number)

      user.reload
      result.should be_falsey
      user.card_number.should be_nil
      user.errors[:card_number].should include(I18n.t('user.card_number_format'))
    end
  end
end
