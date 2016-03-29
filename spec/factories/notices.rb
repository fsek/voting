# encoding: UTF-8
FactoryGirl.define do
  factory :notice do
    title
    description
    public true
    sort { rand(10..100) }
  end
end
