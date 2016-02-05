class PermissionUser < ActiveRecord::Base
  belongs_to :permission
  belongs_to :user
  validates :user_id, :permission_id, presence: true
  validates :user_id, uniqueness: { scope: :permission_id }
end
