class RemoveOrderedAtFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :ordered_at, :datetime
  end
end
