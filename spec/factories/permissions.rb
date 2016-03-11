FactoryGirl.define do
  factory :permission do
    subject_class { ['News', 'CafeWork', 'Post', 'Rent', 'Event'].sample }
    action { ['read', 'create', 'update', 'manage', 'new'].sample }

    trait :admin do
      subject_class :all
      action :manage
    end
  end
end
