class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: false
      t.datetime :ordered_at, null: false
      t.string :status, null: false
      t.references :address, foreign_key: true, null: false

      t.timestamps
    end
  end
end
