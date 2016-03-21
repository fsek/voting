require 'rails_helper'

RSpec.feature 'votes' do
  describe 'voting' do
    it 'manages to create new vote_post' do
      vote = create(:vote, :with_options)
      user = create(:user, presence: true, votecode: 'abcd123')
      vote.update!(open: true)
      LoginPage.new.visit_page.login(user)

      page.visit votes_path
      page.status_code.should eq(200)

      first(:linkhref, new_vote_vote_post_path(vote)).click
      page.status_code.should eq(200)

      fill_in 'vote_post[votecode]', with: 'abcd123'
      select vote.vote_options.first, from: 'vote_post[vote_option_ids][]'

      find('#vote_post_submit').click

      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t(:success_create))
    end
  end
end
