# frozen_string_literal: true

# Handles display and export of user attendance list
module Admin
  class AttendanceListsController < ApplicationController
    def show
      @users = User.all_attended
    end
  end
end
