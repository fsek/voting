# encoding: UTF-8
FactoryGirl.define do
  factory :contact do |c|
    name "Spindelmän"
    email
    text { generate(:description) }

    trait :with_message do
      message { build(:contact_message) }
    end
  end
end
