# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageMailer, type: :mailer do
  it 'sends to the given contact' do
    message = Message.new(email: 'david@rostsystem.se',
                          message: 'Waow',
                          name: 'David')
    mail = MessageMailer.email(message)

    mail.cc.should eq(['david@rostsystem.se'])
  end

  it 'includes the text' do
    message = Message.new(email: 'david@rostsystem.se',
                          message: 'Waow - mitt meddelande',
                          name: 'David')
    mail = MessageMailer.email(message)

    mail.body.should include('Waow - mitt meddelande')
  end
end
