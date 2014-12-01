class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :invoice, null: false, index: true
      t.string :charge_type, null: false
      t.date :date_due, null: false
      t.boolean :automatic_payment, null: false
      t.decimal :amount, null: false
      t.date     :period_first
      t.date     :period_last
      t.timestamps
    end
  end
end
