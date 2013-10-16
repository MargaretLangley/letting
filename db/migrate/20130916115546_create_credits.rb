class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer  :payment_id, null: false
      t.integer  :account_id, null: false
      t.integer  :debt_id,    null: false
      t.date     :on_date,    null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :credits, :debt_id
    add_index :credits, :account_id
    add_index :credits, :payment_id
  end
end
