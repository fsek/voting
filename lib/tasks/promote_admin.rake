task :promote_admin => :environment do
  u = User.first
  perm = Permission.find_or_create_by!(subject_class: :all, action: :manage)
  PermissionUser.find_or_create_by!(permission: perm, user: u)
end
