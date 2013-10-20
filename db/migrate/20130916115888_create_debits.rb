class CreateDebits < ActiveRecord::Migration
  def change
    create_table :debits do |t|
      t.integer  :account_id, null: false
      t.integer  :charge_id,  null: false
      t.date     :on_date,    null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.integer  :debit_generator_id, null: false
      t.timestamps
    end

    add_index :debits, :charge_id
    add_index :debits, :account_id
    add_index :debits, :debit_generator_id
    add_index :debits, [:charge_id, :on_date], unique: true
  end
end
