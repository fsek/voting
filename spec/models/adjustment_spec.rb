# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adjustment, type: :model do
  describe 'ordering' do
    it 'adds new adjustments to the bottom' do
      user = create(:user)

      sub_item1 = create(:sub_item, status: :current)
      sub_item2 = create(:sub_item)
      sub_item3 = create(:sub_item)

      adjustment1 = create(:adjustment, user: user, sub_item: sub_item1)
      adjustment2 = create(:adjustment, user: user, sub_item: sub_item2)
      adjustment3 = create(:adjustment, user: user, sub_item: sub_item3)

      expect(user.adjustments).to eq([adjustment1, adjustment2, adjustment3])
    end

    it 'moves the last adjustment to the top' do
      user = create(:user)

      sub_item1 = create(:sub_item, status: :current)
      sub_item2 = create(:sub_item)
      sub_item3 = create(:sub_item)

      adjustment1 = create(:adjustment, user: user, sub_item: sub_item1)
      adjustment2 = create(:adjustment, user: user, sub_item: sub_item2)
      adjustment3 = create(:adjustment, user: user, sub_item: sub_item3)

      adjustment3.update(position: 1)

      expect(user.adjustments).to eq([adjustment3, adjustment1, adjustment2])
    end

    it 'deletes an adjustment' do
      user = create(:user)

      sub_item1 = create(:sub_item, status: :current)
      sub_item2 = create(:sub_item)
      sub_item3 = create(:sub_item)

      adjustment1 = create(:adjustment, user: user, sub_item: sub_item1)
      adjustment2 = create(:adjustment, user: user, sub_item: sub_item2)
      adjustment3 = create(:adjustment, user: user, sub_item: sub_item3)

      adjustment2.destroy!

      expect(user.adjustments).to eq([adjustment1, adjustment3])
    end

    it 'moves up an adjustment' do
      user = create(:user)

      sub_item = create(:sub_item, status: :current)

      a1 = create(:adjustment, user: user, sub_item: sub_item)
      a2 = create(:adjustment, user: user, sub_item: sub_item)
      a3 = create(:adjustment, user: user, sub_item: sub_item)
      a4 = create(:adjustment, user: user, sub_item: sub_item)
      a5 = create(:adjustment, user: user, sub_item: sub_item)

      a4.update!(position: 2)
      user.reload

      expect(user.adjustments.map(&:id)).to eq([a1, a4, a2, a3, a5].map(&:id))
    end
  end
end
