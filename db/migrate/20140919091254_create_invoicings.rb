class CreateInvoicings < ActiveRecord::Migration
  def change
    create_table :invoicings do |t|
      t.string "property_range", null: false
      t.date   :period_first,      null: false
      t.date   :period_last,       null: false
      t.timestamps
    end
  end
end
