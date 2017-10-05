source 'https://rubygems.org'

# Do not forget to update in .ruby-version and circle.yml
ruby '2.4.1'

gem 'rails', '4.2.8'

gem 'bootstrap-datepicker-rails'
gem 'bootstrap-sass'
gem 'cancancan'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'cocoon'
gem 'config'
gem 'cookies_eu'
gem 'datetimepicker-rails',
    git: 'https://github.com/zpaulovics/datetimepicker-rails',
    branch: 'master', submodules: true
gem 'devise'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'pagedown-bootstrap-rails'
gem 'paranoia', '~> 2.0'
gem 'pg'
gem 'puma'
gem 'ranked-model'
gem 'redcarpet'
gem 'rollbar'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'turbolinks', '>= 2.5.3', '< 5.0'
gem 'uglifier'
gem 'wice_grid', git: 'https://github.com/leikind/wice_grid.git', branch: 'rails3'

group :production do
  gem 'rails_12factor'
  gem 'therubyracer', platform: :ruby
end

group :development, :test do
  gem 'better_errors'
  gem 'bullet'
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-example_steps'
  gem 'rspec-rails'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
