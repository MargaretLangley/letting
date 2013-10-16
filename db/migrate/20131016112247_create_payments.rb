class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :account_id, null: false
      t.date :on_date, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end

    add_index :payments, :account_id
  end
end
