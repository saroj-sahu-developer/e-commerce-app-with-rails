class AddDefaultAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :default_address_id, :integer
    add_foreign_key :users, :addresses, column: :default_address_id, on_delete: :nullify
  end
end
