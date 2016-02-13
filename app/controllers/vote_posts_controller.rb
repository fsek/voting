class VotePostsController < ApplicationController
load_permissions_and_authorize_resource

  def new
    @vote = Vote.find(params[:vote_id])
    @vote_post = VotePost.new

    if !@vote.open
      redirect_to votes_path
    end
  end

  def create
    @vote = Vote.find(params[:vote_id])
    @vote_post = @vote.vote_posts.build(vote_post_params)
    @vote_post.user = current_user
    option = VoteOption.find(vote_post_params[:vote_option_id])

    if VoteService.user_vote(@vote_post, option)
      redirect_to votes_path
    else
      render :new, status: 422
    end
  end

  private

  def vote_post_params
    params.require(:vote_post).permit(:id, :votecode, :vote_id, :vote_option_id)
  end
end
