# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def about; end

  def cookies_information; end

  def index
    @start_page = StartPage.new
  end

  def terms; end
end
