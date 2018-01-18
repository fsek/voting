# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Voting
  class Application < Rails::Application
    config.load_defaults 5.1
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config',
                                                 'locales',
                                                 '**',
                                                 '*.{rb,yml}')]
    config.i18n.default_locale = :sv

    config.time_zone = 'Stockholm'
    config.filter_parameters += %i[password
                                   password_confirmation
                                   vote_option_ids]
  end
end

Rack::Utils.multipart_part_limit = 512
