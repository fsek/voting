# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build_stubbed(:user)).to be_valid
  end

  describe 'card number' do
    it 'only allows integers' do
      user = User.new(card_number: '1111-2222-3333-bbbb')
      user.valid?
      expect(user.errors[:card_number]).to \
        include(t('model.user.card_number_format'))
    end

    it 'should only allow 16 characters' do
      user = User.new(card_number: '1111-2222-3333-4444')
      user.valid?
      expect(user.errors[:card_number]).to be_empty
      user.card_number = '1234-5678'
      user.valid?
      expect(user.errors[:card_number]).to \
        include(t('model.user.card_number_format'))
    end

    it 'should be unique' do
      create(:user, card_number: '1111-2222-3333-4444')
      user = User.new(card_number: '1111-2222-3333-4444')
      user.valid?
      expect(user.errors[:card_number]).to include(t('errors.messages.taken'))
    end
  end

  describe 'validate email as stilid@student.lu.se' do
    it 'allows student email Stil-ID' do
      user = User.new(email: 'tfy16hal@student.lu.se')
      user.valid?
      expect(user.errors[:email]).to be_empty
    end

    it 'allows student email Lucat-ID' do
      user = User.new(email: 'hi6122al-x@student.lu.se')
      user.valid?
      expect(user.errors[:email]).to be_empty
    end

    it 'should be invalid' do
      user = User.new(email: 'hilbert.alg.237@student.lu.se')
      user.valid?
      expect(user.errors[:email]).to \
        include(t('model.user.email_format'))
    end

    it 'should be invalid' do
      user = User.new(email: 'tfy16hal@google.lu.se')
      user.valid?
      expect(user.errors[:email]).to \
        include(t('model.user.email_format'))
    end
  end
end
