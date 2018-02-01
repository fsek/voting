# frozen_string_literal: true

namespace :dev do
  desc 'Loads some stuff into the database for local testing'
  task(data: :environment) do
    u = User.find_or_initialize_by(email: 'admin123@student.lu.se',
                                   firstname: 'Hilbert-Admin',
                                   lastname: 'Älg',
                                   role: :admin)
    u.password = 'passpass'
    u.confirmed_at = Time.zone.now
    u.save

    a = User.find_or_initialize_by(email: 'user1234@student.lu.se',
                                   firstname: 'Hilbert', lastname: 'Älg')
    a.confirmed_at = Time.zone.now
    a.password = 'passpass'
    a.save

    puts 'Sign in with admin123@student.lu.se or user1234@student.lu.se and passpass.'
    News.find_or_create_by(title: 'Välkommen till Röstsystem',
                           content: '**Skriv i Markdown, det är coole**',
                           user: User.first)
    News.find_or_create_by(title: 'Nu börjar det roliga!',
                           content: 'Waow!',
                           user: User.first)
  end
end
