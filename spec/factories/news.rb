
# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    title
    content { generate(:description) }
    user
  end
end
