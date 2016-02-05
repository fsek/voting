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
                      public: true,
                      d_publish: 2.days.ago)
      create(:notice, title: 'Second - private',
                      public: false,
                      d_publish: 2.days.ago)
      create(:notice, title: 'Third - unpublished',
                      public: true,
                      d_publish: 2.days.from_now)

      start = StartPage.new(member: false)

      start.notices.map(&:title).should eq(['First'])
    end

    it 'lists all published notices for member' do
      create(:notice, title: 'First',
                      public: true,
                      d_publish: 2.days.ago,
                      sort: 10)
      create(:notice, title: 'Second - private',
                      public: false,
                      d_publish: 2.days.ago,
                      sort: 20)
      create(:notice, title: 'Third - unpublished',
                      public: true,
                      d_publish: 2.days.from_now,
                      sort: 30)

      start = StartPage.new(member: true)

      start.notices.map(&:title).should eq(['First', 'Second - private'])
    end
  end
end
