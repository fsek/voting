namespace :db do
  desc 'Loads some stuff into the database for local testing'
  task(populate_test: :environment) do
    u = User.find_or_initialize_by(email: 'admin123@student.lu.se',
                                   firstname: 'Hilbert-Admin',
                                   lastname: 'Älg',
                                   role: :admin)
    u.password = 'passpass'
    u.confirmed_at = Time.zone.now
    u.save!

    a = User.find_or_initialize_by(email: 'user1234@student.lu.se',
                                   firstname: 'Hilbert', lastname: 'Älg')
    a.confirmed_at = Time.zone.now
    a.password = 'passpass'
    a.save!
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
