class CreateDueOns < ActiveRecord::Migration
  def change
    create_table :due_ons do |t|
      t.integer :day
      t.integer :month
      t.integer :charge_id

      t.timestamps
    end
    add_index :due_ons, :charge_id
  end
end
