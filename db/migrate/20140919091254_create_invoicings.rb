class CreateInvoicings < ActiveRecord::Migration
  def change
    create_table :invoicings do |t|
      t.string "property_range", null: false
      t.date    "start_date",    null: false
      t.date    "end_date",      null: false
      t.timestamps
    end
  end
end
