# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle documents for items', as: :request) do
  let(:user) { create(:user, role: :user) }
  let(:document) { create(:document) }

  it 'needs access' do
    get(document_url(document))
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'shows user document' do
    sign_in(user)
    get(document_url(document))
    expect(response).to redirect_to(document.view)
    expect(document.view).to_not be_nil
  end

  it 'redirects to root if document not found' do
    allow_any_instance_of(Document).to receive(:view).and_return(nil)
    sign_in(user)
    get(document_url(document))
    expect(response).to redirect_to(root_url)
  end
end
