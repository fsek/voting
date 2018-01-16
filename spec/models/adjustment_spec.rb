# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adjustment, type: :model do
  describe 'ordering' do
    it 'adds new adjustments to the bottom' do
      user = create(:user)

      agenda1 = create(:agenda, status: :current)
      agenda2 = create(:agenda)
      agenda3 = create(:agenda)

      adjustment1 = create(:adjustment, user: user, agenda: agenda1)
      adjustment2 = create(:adjustment, user: user, agenda: agenda2)
      adjustment3 = create(:adjustment, user: user, agenda: agenda3)

      user.adjustments.rank(:row_order).should eq [adjustment1, adjustment2, adjustment3]
    end

    it 'moves the last adjustment to the top' do
      user = create(:user)

      agenda1 = create(:agenda, status: :current)
      agenda2 = create(:agenda)
      agenda3 = create(:agenda)

      adjustment1 = create(:adjustment, user: user, agenda: agenda1)
      adjustment2 = create(:adjustment, user: user, agenda: agenda2)
      adjustment3 = create(:adjustment, user: user, agenda: agenda3)

      adjustment3.update(row_order_position: 0)

      user.adjustments.rank(:row_order).should eq [adjustment3, adjustment1, adjustment2]
    end

    it 'deltes an adjustment' do
      user = create(:user)

      agenda1 = create(:agenda, status: :current)
      agenda2 = create(:agenda)
      agenda3 = create(:agenda)

      adjustment1 = create(:adjustment, user: user, agenda: agenda1)
      adjustment2 = create(:adjustment, user: user, agenda: agenda2)
      adjustment3 = create(:adjustment, user: user, agenda: agenda3)

      adjustment2.destroy

      user.adjustments.rank(:row_order).should eq [adjustment1, adjustment3]
    end

    it 'moves up an adjustment' do
      user = create(:user)

      agenda = create(:agenda, status: :current)

      a1 = create(:adjustment, user: user, agenda: agenda)
      a2 = create(:adjustment, user: user, agenda: agenda)
      a3 = create(:adjustment, user: user, agenda: agenda)
      a4 = create(:adjustment, user: user, agenda: agenda)
      a5 = create(:adjustment, user: user, agenda: agenda)

      a4.update(row_order_position: 1)

      user.adjustments.rank(:row_order).should eq [a1, a4, a2, a3, a5]
    end
  end
end
