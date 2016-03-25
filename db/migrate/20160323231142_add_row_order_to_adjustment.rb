class AddRowOrderToAdjustment < ActiveRecord::Migration
  def change
    add_column :adjustments, :row_order, :integer
  end
end
