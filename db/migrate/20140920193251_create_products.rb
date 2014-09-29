class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :invoice, null: false, index: true
      t.string :charge_type
      t.date :date_due
      t.decimal :amount
      t.date     :period_first,      null: false
      t.date     :period_last,       null: false
      t.timestamps
    end
  end
end
