FactoryGirl.define do
  factory :permission_user do
    permission
    user

    trait :admin do
      permission { association(:permission, :admin, strategy: @build_strategy.class) }
    end
  end
end
