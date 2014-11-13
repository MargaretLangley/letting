class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :run, null: false, index: true
      t.belongs_to :invoice_account, null: false, index: true
      t.text     "billing_address", null: false
      t.integer  "property_ref",    null: false
      t.date     "invoice_date", null: false
      t.text     "property_address", null: false
      t.decimal  "total_arrears",     precision: 8, scale: 2, null: false
      t.text     "client_address", null: false
      t.timestamps
    end
  end
end
