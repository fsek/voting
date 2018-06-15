# frozen_string_literal: true

namespace :cleanup do
  desc('Clean up system after a meeting')
  task(keep_users: :environment) do
    User.all.each { |u| u.update!(votecode: nil) }
    Audit.all.each(&:delete)
    Adjustment.with_deleted.each(&:really_delete)
    VoteOption.with_deleted.each(&:really_delete)
    VotePost.with_deleted.each(&:really_delete)
    Vote.with_deleted.each(&:really_delete)
    Item.with_deleted.each(&:really_destroy!)

    str = "Cleaned up\n=========\n"
    str += "Audits: #{Audit.all.count}\n"
    str += "Adjustments: #{Adjustment.with_deleted.count}\n"
    str += "Votes: #{Vote.with_deleted.count}\n"
    str += "Items: #{Item.with_deleted.count}\n"
    puts(str)
  end
end
