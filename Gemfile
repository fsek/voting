source 'https://rubygems.org'

# Do not forget to update in .ruby-version, Capfile and circle.yml
ruby '2.3.0'

gem 'rails', '4.2.5.1'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'cancancan'
# Need to use this for multiple file upload
# https://github.com/carrierwaveuploader/carrierwave#multiple-file-uploads
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'cookies_eu'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'devise'
gem 'font-awesome-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'pg'
gem 'puma'
gem 'quiet_assets'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'turbolinks'
gem 'uglifier'
gem 'cocoon'
# Introduces feature needed in tables, no errors when updating
gem 'wice_grid', '3.6.0.pre4'

group :production do
  gem 'rails_12factor'
  gem 'therubyracer', platform: :ruby
end

group :development, :test do
  gem 'better_errors'
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'i18n-tasks'
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
