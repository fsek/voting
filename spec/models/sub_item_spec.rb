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

  it 'can only have one open' do
    create(:sub_item, status: :current)
    sub_item = build(:sub_item, status: :current)
    sub_item.valid?
    expect(sub_item.errors[:status]).to \
      include(I18n.t('model.sub_item.errors.already_one_current'))
  end

  it 'can not close if associated vote is open' do
    sub_item = create(:sub_item, status: :current)
    create(:vote, status: :open, sub_item: sub_item)
    expect(sub_item.update(status: :closed)).to be_falsey
    expect(sub_item.errors[:status]).to \
      include(I18n.t('model.sub_item.errors.vote_open'))
  end

  it 'can print even when parent item was deleted' do
    sub_item = create(:sub_item)
    str = sub_item.to_s
    sub_item.item.destroy!
    sub_item.reload
    expect(sub_item.to_s).to eq(str)
  end
end
