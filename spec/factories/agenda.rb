FactoryGirl.define do
  factory :agenda do
    title
    index 1
    sort_index { sort_order }
    status Agenda::FUTURE
  end
end
