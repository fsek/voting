# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoteMailer, type: :mailer do
  it 'sends to the given contact' do
    user = build(:user, email: 'user1234@student.lu.se',
                        votecode: '1234567')
    mail = VoteMailer.votecode(user)

    mail.to.should eq(['user1234@student.lu.se'])
  end

  it 'includes the text' do
    user = build(:user, email: 'user1234@student.lu.se',
                        votecode: '1234567')
    mail = VoteMailer.votecode(user)

    mail.body.should include('1234567')
  end
end
