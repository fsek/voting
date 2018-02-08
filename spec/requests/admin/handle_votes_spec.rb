# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle votes', as: :request) do
  let(:chairman) { create(:user, role: :chairman) }

  it 'needs access' do
    get(new_admin_vote_url)
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'static pages' do
    sign_in(chairman)
    create_list(:vote, 3)
    get(admin_votes_url)
    expect(response).to have_http_status(200)
    get(new_admin_vote_url)
    expect(response).to have_http_status(200)
    get(edit_admin_vote_url(Vote.first))
    expect(response).to have_http_status(200)
  end

  describe 'create' do
    it 'correct attributes' do
      sub_item = create(:sub_item)
      option_attr = { '12345678': { title: 'NCO' } }
      attributes = { title: 'Ordförande',
                     sub_item_id: sub_item.to_param,
                     vote_options_attributes: option_attr }
      sign_in(chairman)

      expect do
        post(admin_votes_url, params: { vote: attributes })
      end.to change(Vote, :count).by(1)

      vote = Vote.last
      expect(response).to redirect_to(edit_admin_vote_path(vote))
      expect(vote.vote_options.map(&:title)).to eq(['NCO'])

      follow_redirect!
      expect(response).to have_http_status(200)
    end

    it 'incorrect attributes' do
      sign_in(chairman)

      expect do
        post(admin_votes_url, params: { vote: { title: '' } })
      end.to change(Vote, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    before(:each) do
      sign_in(chairman)
      @vote = create(:vote, title: 'Beginning title', status: :future)
    end

    it 'correct attributes' do
      attributes = { vote: { title: 'Better title', position: 1 } }
      patch(admin_vote_url(@vote), params: attributes)

      @vote.reload
      expect(response).to redirect_to(edit_admin_vote_url(@vote))
      expect(@vote.title).to eq('Better title')
    end

    it 'incorrect attributes' do
      attributes = { vote: { title: '' } }
      patch(admin_vote_url(@vote), params: attributes)

      @vote.reload
      expect(response).to have_http_status(422)
      expect(@vote.title).to eq('Beginning title')
    end

    it 'works if closed' do
      vote = create(:vote, status: :closed)
      attributes = { vote: { title: 'Better title' } }
      patch(admin_vote_url(vote), params: attributes)
      vote.reload
      expect(response).to redirect_to(edit_admin_vote_url(vote))
      expect(vote.title).to eq('Better title')
    end

    it 'fails if open' do
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :open, title: 'Open title',
                           sub_item: sub_item)
      attributes = { vote: { title: 'New title' } }
      patch(admin_vote_url(vote), params: attributes)
      vote.reload
      expect(response).to redirect_to(admin_votes_url)
      expect(vote.title).to eq('Open title')
    end
  end

  it 'destroy' do
    sign_in(chairman)
    vote = create(:vote)

    expect do
      delete(admin_vote_url(vote))
    end.to change(Vote, :count).by(-1)

    expect(response).to redirect_to(admin_votes_url)
  end
end
