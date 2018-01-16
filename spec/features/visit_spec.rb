# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'visits paths' do
  paths = {
    contacts: [:index],
    votes: [:index],
    static_pages: %i[about cookies_information terms]
  }

  paths.each do |key, value|
    value.each do |v|
      scenario %(Controller: #{key}, action: #{v}) do
        user = create(:user)
        create(:agenda)
        LoginPage.new.visit_page.login(user)

        if %i[show edit].include?(v)
          resource = create(key.to_s.split('/').last.singularize.to_sym)
          page.visit url_for(controller: key, action: v, id:
                             resource.to_param)
        else
          page.visit url_for(controller: key, action: v)
        end

        page.status_code.should eq(200)
      end
    end
  end
end
