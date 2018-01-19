# frozen_string_literal: true

class VoteStatusView
  attr_accessor :vote_post
  attr_reader :adjusted, :sub_item, :vote

  def initialize
    @adjusted = User.present.count
    @sub_item = SubItem.current
    @vote = Vote.current
  end
end
