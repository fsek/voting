# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    title
    position { |n| n }
  end
end
