require 'rails_helper'

RSpec.describe GlobalMenus do
  describe '#info_menus' do
    it 'lists info menus' do
      create(:menu, name: 'Second', location: Menu::INFO, index: 20)
      create(:menu, name: 'First', location: Menu::INFO, index: 10)
      create(:menu, name: 'Not listed', location: Menu::VOTING, index: 20)

      menus = GlobalMenus.new

      menus.info_menus.map(&:name).should eq(['First',
                                              'Second'])
    end

    it 'returns empty array if no menus' do
      menus = GlobalMenus.new
      menus.info_menus.should eq([])
    end
  end

  describe '#voting_menus' do
    it 'lists voting menus' do
      create(:menu, name: 'Second', location: Menu::VOTING, index: 20)
      create(:menu, name: 'First', location: Menu::VOTING, index: 10)
      create(:menu, name: 'Not listed', location: Menu::INFO, index: 20)

      menus = GlobalMenus.new

      menus.voting_menus.map(&:name).should eq(['First',
                                                'Second'])
    end
  end
end
