# frozen_string_literal: true

FactoryBot.define do
  factory :sub_item do
    item
    title
    position { |n| n }
  end
end
