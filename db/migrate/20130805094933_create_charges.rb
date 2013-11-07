class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :charge_type, null: false
      t.string :due_in, null: false
      t.decimal :amount, precision: 8, scale: 2, null:false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :account_id, null: false
      t.timestamps
    end
    add_index :charges, :account_id

  end
end
