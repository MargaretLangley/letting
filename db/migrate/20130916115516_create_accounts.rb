class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :property_id, index: true
      t.timestamps
    end
  end
end
