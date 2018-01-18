class AdjustmentsUseSubItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference(:adjustments, :agenda, index: true, foreign_key: true)
    add_reference(:adjustments, :sub_item, index: true, foreign_key: true)
  end
end
