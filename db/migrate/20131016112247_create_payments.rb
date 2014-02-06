class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :account_id, null: false, index: true
      t.datetime :on_date, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
