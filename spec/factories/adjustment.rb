# frozen_string_literal: true

FactoryBot.define do
  factory :adjustment do
    agenda
    user
    presence true
  end
end
