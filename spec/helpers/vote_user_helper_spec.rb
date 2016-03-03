require 'rails_helper'

RSpec.describe VoteUserHelper do
  describe 'vote_user_state_link' do
    it 'links to not_present if user present' do
      user = build_stubbed(:user, presence: true)
      result = helper.vote_user_state_link(user)

      result.should include(I18n.t('user.make_not_present'))
    end

    it 'links to present if user not present' do
      user = build_stubbed(:user, presence: false)
      result = helper.vote_user_state_link(user)

      result.should include(I18n.t('user.make_present'))
    end
  end
end
