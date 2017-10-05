FactoryGirl.define do
  factory :user do
    email
    password '12345678'
    firstname
    lastname
    confirmed_at { 10.days.ago }
    role :user

    trait :admin do
      role :admin
    end
  end

  trait :unconfirmed do
    confirmed_at nil
    confirmation_token 'confirmmyaccount'
    confirmation_sent_at { Time.zone.now }
  end

  trait :reset_password do
    reset_password_token 'resetmypassword'
    reset_password_sent_at { Time.zone.now }
  end
end
