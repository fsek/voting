# frozen_string_literal: true

module ItemService
  def self.create_item(item)
    begin
      Item.transaction do
        item.save!
        SubItem.create!(item: item, title: 'Base', position: 0)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      # invalid.record.errors.full_messages
      item.valid?
      return false
    end
    true
  end
end
