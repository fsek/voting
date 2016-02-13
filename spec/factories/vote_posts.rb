FactoryGirl.define do
  factory :vote_post do
    to_create { |instance| instance.save(validate: false) }
    votecode { generate(:phone) }
    vote
  end
end
