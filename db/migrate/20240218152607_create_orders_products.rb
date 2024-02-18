class CreateOrdersProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :orders_products do |t|
      t.references :order, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false
      t.integer :product_quantity, null:false
      t.decimal :product_unit_price, null:false
      
      t.timestamps
    end
  end
end
