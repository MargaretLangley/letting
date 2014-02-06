class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.belongs_to  :account, null: false, index: true
      t.belongs_to  :charge,  null: false, index: true
      t.belongs_to  :payment, null: false, index: true
      t.date     :on_date,    null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
