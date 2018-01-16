# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = %i[expect should]
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = %i[expect should]
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?

  # Need to be disabled to allow :should syntax
  # config.disable_monkey_patching!

  config.order = :random

  Kernel.srand config.seed

  # Nice for checking, not working on Circle CI
  # config.profile_examples = 10
end
