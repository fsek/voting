# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    email
    password '12345678'
    firstname
    lastname
    confirmed_at { 10.days.ago }

    trait :admin do
      password '12345678'
      with_admin_post
    end
  end

  factory :admin, class: 'User' do
    email
    password '12345678'
    firstname
    lastname
    confirmed_at { Time.zone.now }
    with_admin_post
  end

  trait :with_admin_post do
    ##
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
