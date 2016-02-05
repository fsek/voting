class VotesController < ApplicationController
load_permissions_and_authorize_resource

  def index
    @votes_grid = initialize_grid(Vote.where(open: true))
  end
  
end