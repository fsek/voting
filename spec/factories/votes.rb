FactoryGirl.define do
  factory :vote do
    title
    open false

    trait :with_options do
      transient do
        option_count 3
      end

      after(:create) do |vote, evaluator|
        create_list(:vote_option, evaluator.option_count, vote: vote)
      end
    end
  end
end
