# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Set current agenda', as: :request) do
  let(:adjuster) { create(:user, role: :adjuster) }
  describe 'PATCH #set_current' do
    it 'makes closed @agenda current' do
      sign_in(adjuster)
      agenda = create(:agenda, status: :closed)

      patch(admin_current_agenda_path(agenda), xhr: true)
      expect(response).to have_http_status(200)

      agenda.reload
      expect(agenda.current?).to be_truthy
      expect(Agenda.now).to eq(agenda)
    end

    it 'doesnt work if there already is a current agenda' do
      create(:agenda, status: :current)
      agenda = create(:agenda, status: :closed)

      patch(admin_current_agenda_path(agenda), xhr: true)
      expect(response).to have_http_status(200)

      agenda.reload
      expect(agenda.current?).to be_falsey
      expect(Agenda.now.id).to_not eq(agenda.id)
    end
  end

  describe 'PATCH #set_closed' do
    it 'makes current @agenda closed' do
      sign_in(adjuster)
      agenda = create(:agenda, status: :current)

      delete(admin_current_agenda_path(agenda), xhr: true)
      expect(response).to have_http_status(200)

      agenda.reload
      expect(agenda.closed?).to be_truthy
      expect(Agenda.now).to_not eq(agenda)
    end

    it 'doesnt work if a associated vote is open' do
      sign_in(adjuster)
      agenda = create(:agenda, status: :current)
      create(:vote, status: :open, agenda: agenda)

      delete(admin_current_agenda_path(agenda), xhr: true)

      agenda.reload
      expect(agenda.current?).to be_truthy
    end
  end
end
