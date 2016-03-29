require 'rails_helper'

RSpec.describe StartPage do
  describe '#news' do
    it 'lists five news' do
      create(:news, title: 'First')
      create(:news, title: 'Second', created_at: 2.minutes.ago)
      create(:news, title: 'Third', created_at: 3.minutes.ago)
      create(:news, title: 'Fourth', created_at: 4.minutes.ago)
      create(:news, title: 'Fifth', created_at: 5.minutes.ago)
      create(:news, title: 'Sixth', created_at: 6.minutes.ago)

      start = StartPage.new

      start.news.map(&:title).should eq(['First',
                                         'Second',
                                         'Third',
                                         'Fourth',
                                         'Fifth'])
    end
  end

  describe '#notices' do
    it 'lists public published notices' do
      create(:notice, title: 'First',
                      public: true)
      create(:notice, title: 'Second - private',
                      public: false)

      start = StartPage.new(signed_in: false)

      start.notices.map(&:title).should eq(['First'])
    end

    it 'lists all published notices for signed in' do
      create(:notice, title: 'Second - private',
                      public: false,
                      sort: 20)
      create(:notice, title: 'First',
                      public: true,
                      sort: 10)

      start = StartPage.new(signed_in: true)

      start.notices.map(&:title).should eq(['First', 'Second - private'])
    end
  end
end
