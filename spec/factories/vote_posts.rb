FactoryGirl.define do
  factory :vote_post do
    to_create { |instance| instance.save(validate: false) }
    votecode
    vote
    user
  end

  sequence(:votecode) { |n| "abcd#{n}68" }
end
