# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'votes' do
  it 'manages to create new vote_post', js: true do
    sub_item = create(:sub_item, status: :current)
    vote = create(:vote, :with_options, sub_item: sub_item)
    user = create(:user, presence: true, votecode: 'abcd123')
    vote.update!(status: :open)
    LoginPage.new.visit_page.login(user)

    page.visit(votes_path)

    first(:linkhref, vote_vote_posts_path(vote)).click

    fill_in('vote_post[votecode]', with: 'abcd123')
    select(vote.vote_options.first, from: 'vote_post[vote_option_ids][]')

    accept_confirm do
      find('#vote_post_submit').click
    end

    expect(page).to have_css('div.alert')
    expect(find('div.alert').text).to include(t('vote_posts.create.success'))
  end
end
