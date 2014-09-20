class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :invoicing, index: true
      t.text     "billing_address", null: false
      t.integer  "property_ref",    null: false
      t.date     "invoice_date", null: false
      t.text     "property_address", null: false
      t.decimal  "arrears",     precision: 8, scale: 2, null: false
      t.decimal  "total_arrears",     precision: 8, scale: 2, null: false
      t.text     "client", null: false
      t.timestamps
    end
  end
end
