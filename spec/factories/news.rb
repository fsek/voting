# encoding: UTF-8
FactoryBot.define do
  factory :news do
    title
    content { generate(:description) }
    user
  end
end
