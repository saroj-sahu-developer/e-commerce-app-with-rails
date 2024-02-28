class ChangeStatusInOrders < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :status, :string, default: 'Initialised', null: false
  end

  def down
    change_column :orders, :status, :string, null: false
  end
end
