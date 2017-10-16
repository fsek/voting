# frozen_string_literal: true

require 'rails_helper'

RSpec.describe("Creates and sends new votecodes", type: :request) do
  it "gets a new votecode" do
    adjuster = create(:user, role: :adjuster)
    user = create(:user, votecode: '')
    sign_in(adjuster)
    get(admin_vote_users_path)
    expect(response).to have_http_status(200)

    patch(admin_votecode_path(user), xhr: true)
    expect(response).to have_http_status(200)
    user.reload
    expect(user.votecode).to_not be_empty
  end
end
