source 'https://rubygems.org'

# Do not forget to update in .ruby-version, Capfile and circle.yml
ruby '2.3.1'

gem 'rails', '4.2.7.1'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'cancancan'
# Need to use this for multiple file upload
# https://github.com/carrierwaveuploader/carrierwave#multiple-file-uploads
gem 'carrierwave',
     git: 'https://github.com/carrierwaveuploader/carrierwave'
gem 'carrierwave-aws'
gem 'cookies_eu'
gem 'datetimepicker-rails',
    git: 'https://github.com/zpaulovics/datetimepicker-rails',
    branch: 'master', submodules: true
gem 'devise'
gem 'font-awesome-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'pagedown-bootstrap-rails'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'turbolinks'
gem 'uglifier'
gem 'cocoon'
gem 'paranoia', '~> 2.0'
gem 'ranked-model'
gem 'redcarpet'
gem 'rollbar'
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
