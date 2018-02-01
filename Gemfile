# frozen_string_literal: true

source 'https://rubygems.org'

# Do not forget to update in .ruby-version and .circleci/config.yml
ruby '2.5.0'

gem 'rails', git: 'https://github.com/rails/rails', branch: '5-2-stable'

gem 'acts_as_list', git: 'https://github.com/swanandp/acts_as_list'
gem 'bootsnap'
gem 'bootstrap', '~> 4.0.0'
gem 'cancancan'
gem 'cocoon'
gem 'coffee-rails' # Only required because of using 5-2-stable
gem 'config'
gem 'cookies_eu'
gem 'devise'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'pagedown-bootstrap-rails'
gem 'paranoia', '~> 2.4'
gem 'pg'
gem 'puma'
gem 'ranked-model'
gem 'redcarpet'
gem 'rollbar'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'textacular'
gem 'turbolinks'
gem 'uglifier'

group :development, :test do
  gem 'better_errors'
  gem 'bullet'
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
end

group :development do
  gem 'i18n-tasks'
  gem 'rubocop'
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', require: false
end
