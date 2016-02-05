module VoteService
  def self.user_vote(post, option)
    VotePost.transaction do
      post.save!
      option.count += 1
      option.save!
    end
  end
end