class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :property_id
      t.timestamps
    end

    add_index :accounts, :property_id
  end
end
