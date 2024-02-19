class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :order, foreign_key: true, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.datetime :payment_date_time
      t.string :payment_mode, null: false
      t.string :payment_status

      t.timestamps
    end
  end
end
