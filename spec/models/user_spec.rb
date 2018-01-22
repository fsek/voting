# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    build_stubbed(:user).should be_valid
  end

  let(:user) { build_stubbed(:user) }

  describe 'validations' do
    new_user = User.new
    it { new_user.should validate_presence_of(:email) }
    it { new_user.should validate_presence_of(:firstname) }
    it { new_user.should validate_presence_of(:lastname) }

    describe 'card number' do
      it 'should only allow integers' do
        user = build(:user)
        user.should_not allow_value('1234-5678-9123-456b').for(:card_number)
      end

      it 'should only allow 16 characters' do
        user = build(:user)
        user.should allow_value('1234-5678-9123-4567').for(:card_number)
        user.should_not allow_value('1234-4567').for(:card_number)
      end

      it 'should be unique' do
        user = build(:user)
        user.should validate_uniqueness_of(:card_number)
      end
    end

    describe 'validate email as stilid@student.lu.se' do
      it 'allows student email Stil-ID' do
        user = build(:user, email: 'tfy16hal@student.lu.se')

        user.should be_valid
      end

      it 'allows student email Lucat-ID' do
        user = build(:user, email: 'hi6122al-x@student.lu.se')

        user.should be_valid
      end

      it 'should be invalid' do
        user = build(:user, email: 'hilbert.alg.237@student.lu.se')

        user.should be_invalid
        user.errors[:email].should include(I18n.t('model.user.email_format'))
      end

      it 'should be invalid' do
        user = build(:user, email: 'tfy16hal@google.lu.se')

        user.should be_invalid
        user.errors[:email].should include(I18n.t('model.user.email_format'))
      end
    end
  end

  describe 'public instance methods' do
    context 'printing' do
      it 'print_id' do
        user.print_id.should eq(%(#{user.firstname} #{user.lastname} (Id: #{user.id})))
      end

      it 'print_email' do
        user.print_email.should eq(%(#{user.firstname} #{user.lastname} <#{user.email}>))
      end

      it 'to_s full name' do
        user.to_s.should eq(%(#{user.firstname} #{user.lastname}))
      end
    end
  end
end
