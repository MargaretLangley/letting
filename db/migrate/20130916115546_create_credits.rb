class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer  :account_id, null: false
      t.integer  :charge_id,  null: false
      t.integer  :payment_id, null: false
      t.date     :on_date,    null: false
      t.integer  :debit_id,   null: true
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end

    add_index :credits, :debit_id
    add_index :credits, :charge_id
    add_index :credits, :account_id
    add_index :credits, :payment_id
  end
end
