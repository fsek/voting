module VoteService
  def self.user_vote(post, option)
    begin
      VotePost.transaction do
        post.save!
        option.count += 1
        option.save!
      end
      true
    rescue
      false
    end
  end
end
