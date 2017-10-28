# frozen_string_literal: true

require 'factory_bot'
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryBot.lint FactoryBot.factories
    ensure
      DatabaseCleaner.clean
    end
  end
end
