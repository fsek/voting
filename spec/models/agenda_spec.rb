require 'rails_helper'

RSpec.describe Agenda, type: :model do
  describe 'validations' do
    it 'can only have one open agenda' do
      create(:agenda, status: Agenda::CURRENT)
      agenda = build(:agenda, status: Agenda::CURRENT)
      agenda.valid?

      agenda.errors[:status].should include I18n.t('agenda.too_many_open')
    end

    it 'can have a parent' do
      agenda1 = build_stubbed(:agenda)
      agenda2 = build_stubbed(:agenda, parent: agenda1)
      agenda2.valid?

      agenda2.should be_valid
    end

    it 'can not have self as parent' do
      agenda = build_stubbed(:agenda)
      agenda.parent = agenda
      agenda.valid?

      agenda.errors[:parent_id].should include I18n.t('agenda.recursion')
    end

    it 'can have a grandparent' do
      agenda1 = build_stubbed(:agenda)
      agenda2 = build_stubbed(:agenda, parent: agenda1)
      agenda3 = build_stubbed(:agenda, parent: agenda2)
      agenda3.valid?

      agenda3.should be_valid
    end

    it 'can not have self as grandparent' do
      agenda1 = build_stubbed(:agenda)
      agenda2 = build_stubbed(:agenda, parent: agenda1)
      agenda1.parent = agenda2
      agenda1.valid?

      agenda1.errors[:parent_id].should include I18n.t('agenda.recursion')
    end
  end
end
