# frozen_string_literal: true

require 'rails_helper'
require 'rake'
Rails.application.load_tasks

RSpec.describe 'Cleanup task' do
  it 'removes everything but users' do
    create_list(:vote, 5)
    create_list(:adjustment, 5)
    expect(Audit.count). to eq(10)
    expect(Adjustment.with_deleted.count). to eq(5)
    expect(Vote.with_deleted.count). to eq(5)
    expect(Item.with_deleted.count). to eq(10)

    Rake::Task['cleanup:keep_users'].invoke

    expect(Audit.count). to eq(0)
    expect(Adjustment.with_deleted.count). to eq(0)
    expect(Vote.with_deleted.count). to eq(0)
    expect(Item.with_deleted.count). to eq(0)
  end
end
