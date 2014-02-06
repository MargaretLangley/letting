class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer  :account_id, null: false, index: true
      t.integer  :charge_id,  null: false, index: true
      t.integer  :payment_id, null: false, index: true
      t.date     :on_date,    null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
