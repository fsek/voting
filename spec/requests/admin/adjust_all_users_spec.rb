# frozen_string_literal: true

require 'rails_helper'

RSpec.describe("Adjust presence of all user", type: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }

  it 'sets all users to not present' do
    sign_in(adjuster)
    create_list(:user, 4, presence: true)
    create(:vote, status: :future)
    create(:sub_item, status: :current)

    delete(admin_attendances_path)
    expect(response).to redirect_to(admin_vote_users_path)

    expect(User.where(presence: true).count).to eq(0)
  end

  it 'does not set users to not present if a vote is open' do
    sign_in(adjuster)
    create_list(:user, 4, presence: true)

    agenda = create(:agenda, status: :current)
    create(:vote, status: :open, agenda: agenda)

    delete(admin_attendances_path)
    expect(response).to redirect_to(admin_vote_users_path)
    expect(User.where(presence: true).count).to eq(4)
  end

  it 'does not set users to not present without a current agenda' do
    sign_in(adjuster)
    create_list(:user, 4, presence: true)
    create(:agenda, status: :future)

    delete(admin_attendances_path)
    expect(response).to redirect_to(admin_vote_users_path)
    expect(User.where(presence: true).count).to eq(4)
  end
end
