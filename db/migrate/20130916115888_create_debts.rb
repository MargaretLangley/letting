class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer  :account_id, null: false
      t.integer  :charge_id,  null: false
      t.date     :on_date,    null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :debts, :charge_id
    add_index :debts, :account_id
  end
end
