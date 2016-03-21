class VotePostsController < ApplicationController
  load_permissions_and_authorize_resource

  def new
    @vote = Vote.find(params[:vote_id])
    if !@vote.open?
      redirect_to votes_path, alert: I18n.t('vote.is_closed')
    else
      @vote_post = VotePost.new
    end
  end

  def create
    @vote = Vote.find(params[:vote_id])
    @vote_post = @vote.vote_posts.build(vote_post_params)
    @vote_post.user = current_user

    if VoteService.user_vote(@vote_post)
      redirect_to votes_path, notice: alert_create(VotePost)
    else
      render :new, status: 422
    end
  end

  private

  def vote_post_params
    params.require(:vote_post).permit(:id, :votecode, vote_option_ids: [])
  end
end
