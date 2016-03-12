FactoryGirl.define do
  factory :agenda do
    title
    index { generate(:agenda_index) }
    sort_index { sort_order }
    status Agenda::FUTURE
  end

  sequence(:agenda_index) { |n| n }
end
