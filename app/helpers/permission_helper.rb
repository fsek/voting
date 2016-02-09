module PermissionHelper
  def permission_confirmation(perm_user: nil)
    if perm_user.present?
      t('permission_user.confirm1') + perm_user.permission.to_s + t('permission_user.confirm2') + perm_user.user.to_s + '?'
    end
  end
end
