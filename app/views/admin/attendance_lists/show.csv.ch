csv << [User.human_attribute_name(:name), User.human_attribute_name(:presence)]

@users.each do |user|
  csv << [user.to_s, split_adjustments(user.adjustments.rank(:row_order))]
end
