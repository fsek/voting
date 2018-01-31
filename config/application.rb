# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'active_job/railtie'
require 'active_model/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
# require 'rails/test_unit/railtie'
require 'sprockets/railtie'
# require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Voting
  class Application < Rails::Application
    config.load_defaults 5.2
    config.i18n.load_path += Dir[Rails.root.join('config',
                                                 'locales',
                                                 '**',
                                                 '*.{rb,yml}')]
    config.i18n.default_locale = :sv

    config.time_zone = 'Stockholm'
  end
end

Rack::Utils.multipart_part_limit = 512
