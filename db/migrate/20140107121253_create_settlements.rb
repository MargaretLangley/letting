class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.belongs_to :credit, index: true
      t.belongs_to :debit, index: true

      t.timestamps
    end
  end
end
