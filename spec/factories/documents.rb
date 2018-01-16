# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    title
    pdf Rack::Test::UploadedFile.new('spec/assets/pdf.pdf')
    sub_item
    position { |n| n }
  end
end
