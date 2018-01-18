# frozen_string_literal: true

module VoteService
  def self.user_vote(post)
    VotePost.transaction do
      if post.vote_option_ids.present?
        post.trim_votecode
        post.selected = post.vote_option_ids.length
        ret = VoteOption.increment_counter(:count, post.vote_option_ids)
        unless ret == post.vote_option_ids.length
          throw ActiveRecord::RecordInvalid
        end
      else
        post.selected = 0
      end
      post.save!
    end
    true
  rescue StandardError
    false
  end

  def self.attends(user)
    return false unless SubItem.current.present?
    User.transaction do
      user.update!(presence: true)
      Adjustment.create!(user: user, sub_item: SubItem.current, presence: true)
    end
  rescue StandardError
    false
  end

  def self.unattends(user)
    return false if Vote.current.present? || SubItem.current.nil?
    User.transaction do
      user.update!(presence: false)
      Adjustment.create!(user: user, sub_item: SubItem.current, presence: false)
    end
  rescue StandardError
    false
  end

  def self.unattend_all
    return if Vote.current.present? || SubItem.current.nil?
    User.transaction do
      User.present.each do |user|
        user.update!(presence: false)
        Adjustment.create!(user: user, sub_item: SubItem.current,
                           presence: false)
      end
    end
  end

  def self.set_votecode(user)
    votecode = votecode_generator
    user.update!(votecode: votecode)
    VoteMailer.votecode(user).deliver_now
  rescue StandardError
    false
  end

  def self.votecode_generator
    votecode = Array.new(7) { [*'0'..'9', *'a'..'z'].sample }.join
    User.with_deleted.any? { |x| x.votecode == votecode } ? votecode_generator : votecode
  end

  def self.reset(vote)
    Vote.transaction do
      vote.update!(present_users: 0, reset: true)
      vote.vote_posts.destroy_all
      vote.vote_options.update_all(count: 0)
    end
  rescue StandardError
    false
  end
end
