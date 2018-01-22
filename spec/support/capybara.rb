# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/rails'

Capybara.add_selector(:linkhref) do
  xpath { |href| ".//a[@href='#{href}']" }
end
