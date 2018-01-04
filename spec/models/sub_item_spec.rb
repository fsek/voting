# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubItem, type: :model do
  describe 'checks number of sub_items' do
    it 'single' do
      item = create(:item, multiplicity: :single)
      sub_item = item.sub_items.build(title: 'First')
      expect(sub_item).to be_valid
      sub_item.save!
      item.reload
      sub_item = item.sub_items.build(title: 'Second')
      expect(sub_item).to be_invalid
    end

    it 'multiple' do
      item = create(:item, multiplicity: :multiple)
      sub_item = item.sub_items.build(title: 'First')
      expect(sub_item).to be_valid
      sub_item.save!
      item.reload
      sub_item = item.sub_items.build(title: 'Second')
      expect(sub_item).to be_valid
    end
  end
end
