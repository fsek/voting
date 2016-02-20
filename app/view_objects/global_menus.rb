class GlobalMenus
  attr_accessor :info_menus, :voting_menus

  def initialize
    menus = Menu.index.group_by(&:location)
    @info_menus = menus[Menu::INFO] || []
    @voting_menus = menus[Menu::VOTING] || []
  end
end
