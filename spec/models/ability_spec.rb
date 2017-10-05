require 'rails_helper'
RSpec.describe Ability do
  standard = :read, :create, :update, :destroy

  ab_not_signed = {
    Document.new(public: true) => { yes: [:read], no: [:create, :update, :destroy] },
    News.new => { yes: [:read], no: [:create, :update, :destroy] },
    Permission.new => { yes: [], no: standard }
  }

  ab_signed = {
    Document.new => { yes: [:read], no: [:create, :update, :destroy] },
    News.new => { yes: [:read], no: [:create, :update, :destroy] },
    Permission.new => { yes: [], no: standard }
  }

  let(:signed) { build_stubbed(:user) }
  subject(:signed_ability) { Ability.new(signed) }

  describe 'not signed in' do
    ab_not_signed.each do |obj, value|
      if value[:yes].present?
        it { signed_ability.should have_abilities(value[:yes], obj) }
      end

      if value[:no].present?
        it { signed_ability.should not_have_abilities(value[:no], obj) }
      end
    end
  end

  describe 'signed in' do
    ab_signed.each do |obj, value|
      if value[:yes].present?
        it { signed_ability.should have_abilities(value[:yes], obj) }
      end

      if value[:no].present?
        it { signed_ability.should not_have_abilities(value[:no], obj) }
      end
    end
  end
end
