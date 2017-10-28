# frozen_string_literal: true

FactoryBot.define do
  sequence(:description) { |n| "This describes the most impressive nr#{n}" }
  sequence(:email) { |n| "tfy#{'%03d' % n}al@student.lu.se" }
  sequence(:firstname) { |n| "Hilbert#{n}" }
  sequence(:lastname) { |n| "Älg#{n}" }
  sequence(:title) { |n| "Titel#{n}" }
end
