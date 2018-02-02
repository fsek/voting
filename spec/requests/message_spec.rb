# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Messages', type: :request) do
  it 'anyone can view message page' do
    get(message_path)
    expect(response).to have_http_status(200)
  end

  describe 'anyone can send an email' do
    it 'valid params' do
      attributes = { name: 'David',
                     email: 'david@google.com',
                     message: 'Jag vill prova kontaktformuläret' }
      post(message_path, params: { message: attributes })
      expect(response).to redirect_to(message_path)
    end

    it 'invalid params' do
      attributes = { name: 'David',
                     email: 'inte_en_epost',
                     message: 'Jag vill prova kontaktformuläret' }
      post(message_path, params: { message: attributes })
      expect(response).to have_http_status(422)
    end
  end
end
