require 'rails_helper'

RSpec.describe PermissionUser, type: :model do
  describe 'validation' do
    it 'validates uniqueness for user_id' do
      permission_user = build(:permission_user)

      permission_user.should validate_uniqueness_of(:user_id).scoped_to(:permission_id)
    end
  end
end
