class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :account, null: false, index: true
      t.datetime :booked_on, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.timestamps null: true
    end
  end
end
