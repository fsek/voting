require 'rails_helper'

RSpec.describe 'promote_admin' do
  include_context 'rake'

  it 'promotes the first user to admin' do
    create(:user)
    subject.invoke
    AdminAbility.new(User.first).can?(:manage, :all).should eq(true)
  end
end
