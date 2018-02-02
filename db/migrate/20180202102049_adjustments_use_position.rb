class AdjustmentsUsePosition < ActiveRecord::Migration[5.2]
  def change
    rename_column(:adjustments, :row_order, :position)
  end
end
