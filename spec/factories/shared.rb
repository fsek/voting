FactoryGirl.define do
  sequence(:description) { |n| "This describes the most impressive nr#{n}" }
  sequence(:email) { |n| "tfy#{'%03d' % n}al@student.lu.se" }
  sequence(:lastname) { |n| "Älg#{n}" }
  sequence(:name) { |n| "Hilbert#{n}" }
  sequence(:firstname) { |n| "Hilbert#{n}" }
  sequence(:phone) { |n| "070#{n}606122" }
  sequence(:stil_id) { |n| "tfy5#{n}hal" }
  sequence(:title) { |n| "Titel#{n}" }
  sequence(:url) { |n| "url#{n}" }
  sequence(:value) { |n| "david#{n}" }
  sequence(:location) { ['MH:A','Hilbert','Kårhuset','Ön-ön','Sjönsjön','Bastun'].sample }
  sequence(:date) { |n| 10.days.from_now + n.days }
end
