FactoryGirl.define do
  factory :agenda do
    title
    index { generate(:agenda_index) }
    sort_index { sort_order }
    status :future
  end

  sequence(:agenda_index) { |n| n }
end
