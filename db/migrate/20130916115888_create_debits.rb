class CreateDebits < ActiveRecord::Migration
  def change
    create_table :debits do |t|
      t.belongs_to  :account, null: false, index: true
      t.belongs_to  :invoice_account, index: true
      t.integer  :charge_id,  null: false, index: true
      t.datetime :on_date,    null: false
      t.date     :period_first,      null: false
      t.date     :period_last,       null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end
    add_index :debits, [:charge_id, :on_date], unique: true
  end
end
