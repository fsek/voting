require 'rails_helper'

RSpec.feature 'visits paths' do
  paths = {
    contacts: [:index, :show],
    documents: [:index, :show],
    news: [:show],
    votes: [:index],
    static_pages: [:about, :cookies_information, :terms]
  }

  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        user = create(:user)
        create(:agenda)
        And 'sign in' do
          LoginPage.new.visit_page.login(user)
        end

        And 'visit' do
          if v == :show || v == :edit
            resource = create(key.to_s.split('/').last.singularize.to_sym)
            page.visit url_for(controller: key, action: v, id:
                               resource.to_param)
          else
            page.visit url_for(controller: key, action: v)
          end
        end

        Then 'check page status' do
          page.status_code.should eq(200)
        end
      end
    end
  end
end
