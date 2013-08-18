class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :charge_type, null: false
      t.string :due_in, null: false
      t.decimal :amount, precision: 8, scale: 2, null:false
      t.integer :property_id, null: false
      t.timestamps
    end
    add_index :charges, :property_id

  end
end
