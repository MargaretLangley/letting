class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :charge_type, null: false
      t.belongs_to :cycle, null: false, index: true
      t.boolean :dormant, default: false, null: false
      t.decimal :amount, precision: 8, scale: 2, null:false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.belongs_to :account, null: false, index: true
      t.timestamps
    end
  end
end
