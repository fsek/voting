module ControllerMacros
  RSpec.configure do |config|
    config.before :each, type: :controller do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability).and_return(@ability)
    end
  end

  def allow_user_to(*args)
    before(:each) do
      @ability.can(*args)
    end
  end
end
