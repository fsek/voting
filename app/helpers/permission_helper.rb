module PermissionHelper
  def permission_confirmation(perm_user: nil)
    if perm_user.present?
      safe_join([t('permission_user.confirm1'),
                 perm_user.permission,
                 t('permission_user.confirm2'),
                 perm_user.user, '?'])
    end
  end
end
