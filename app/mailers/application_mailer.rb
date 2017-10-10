# frozen_string_literal: true

# General class for mailers
class ApplicationMailer < ActionMailer::Base
  require 'digest/sha2'

  default from: 'Röstsystem <rostiga@rostsystem.se>'
  layout 'email'

  protected

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@rostsystem.se>"
  end
end
