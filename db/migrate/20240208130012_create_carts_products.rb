class CreateCartsProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts_products do |t|
      t.references :cart, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false
      t.integer :product_quantity, null: false
      t.timestamps
    end
  end
end
