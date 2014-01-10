class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.references :credit, index: true
      t.references :debit, index: true

      t.timestamps
    end
  end
end
