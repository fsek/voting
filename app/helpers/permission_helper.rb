module PermissionHelper
  def permission_confirmation(perm_user: nil)
    if perm_user.present?
      safe_join([t('permission_user.confirm1'),
                 perm_user.permission,
                 t('permission_user.confirm2'),
                 perm_user.user, '?'])
    end
  end

  def permission_list(user)
    if user.present? && user.permissions.any?
      permissions = []
      user.permissions.each { |p| permissions << permission_list_item(p) }
      content_tag(:ul, safe_join(permissions))
    end
  end

  def permission_list_item(permission)
    content_tag(:li, permission.to_s)
  end
end
