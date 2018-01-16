# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    title
    status :future
    choices 1

    trait :with_options do
      vote_options do |o|
        arr = []
        o.choices.times do
          arr << o.association(:vote_option, strategy: @build_strategy.class)
        end
        arr
      end
    end
  end
end
