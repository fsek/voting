# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agenda, type: :model do
  describe 'validations' do
    it 'can only have one open agenda' do
      create(:agenda, status: :current)
      agenda = build(:agenda, status: :current)
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

    it 'can not close if a associated vote is open' do
      agenda = create(:agenda, status: :current)
      create(:vote, status: :open, agenda: agenda)
      agenda.update(status: :closed)
      agenda.valid?

      agenda.errors[:status].should include I18n.t('agenda.vote_open')
    end

    it 'current_status from child' do
      agenda = create(:agenda, status: :closed)
      child = create(:agenda, status: :current, parent: agenda)

      agenda.current_status.to_s.should eq('current')
    end
  end
end
