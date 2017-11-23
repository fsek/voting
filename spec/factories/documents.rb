# encoding: UTF-8
FactoryBot.define do
  factory :document do
    title
    pdf Rack::Test::UploadedFile.new('spec/assets/pdf.pdf')
    category { ['Styrdokument', 'Protokoll', 'Von Tänen'].sample }
  end
end
