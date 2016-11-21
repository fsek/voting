require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to([:index, :show], Document)

  before(:each) do
    controller.stub(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns a document grid and categories' do
      create(:document, title: 'First document')
      create(:document, title: 'Second document')
      create(:document, title: 'Third document')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns given document as @document' do
      document = create(:document)

      controller.stub(:render)

      controller.should_receive(:send_file).and_return(controller: :render, nothing: true)
      get(:show, id: document.to_param)
    end

    it 'redirects to index if failed' do
      document = create(:document)
      allow_any_instance_of(Document).to receive(:view).and_return(nil)

      get(:show, id: document.to_param)
      response.should redirect_to(documents_path)
    end
  end
end
