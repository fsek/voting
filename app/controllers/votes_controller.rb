class VotesController < ApplicationController
  load_and_authorize_resource

  def index
    @vote_status = VoteStatusView.new
    @vote_status.vote_post = VotePost.where(vote: @vote_status.vote, user: current_user).first
  end
end
