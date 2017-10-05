namespace :db do
  desc 'Loads some stuff into the database for local testing'
  task(populate_test: :environment) do
    # Permissions
    Rake::Task['permissions:load'].invoke
    perm_admin = Permission.find_or_create_by!(subject_class: :all, action: :manage)

    u = User.find_or_initialize_by(email: 'admin123@student.lu.se',
                                   firstname: 'Hilbert-Admin', lastname: 'Älg')
    u.password = 'passpass'
    u.confirmed_at = Time.zone.now
    u.save!

    PermissionUser.find_or_create_by!(permission: perm_admin, user: u)

    a = User.find_or_initialize_by(email: 'user1234@student.lu.se',
                                   firstname: 'Hilbert', lastname: 'Älg')
    a.confirmed_at = Time.zone.now
    a.password = 'passpass'
    a.save!

    # Notice
    Notice.find_or_create_by!(FactoryGirl.attributes_for(:notice))
    Notice.find_or_create_by!(FactoryGirl.attributes_for(:notice))

    # News
    News.find_or_create_by!(title: 'Ett helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Andra helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Tredje helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Fjärde helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Femte helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    # Documents
    FactoryGirl.create(:document)
    FactoryGirl.create(:document)
  end
end
