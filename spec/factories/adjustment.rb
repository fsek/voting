# frozen_string_literal: true

FactoryBot.define do
  factory :adjustment do
    sub_item
    user
    presence true
  end
end
