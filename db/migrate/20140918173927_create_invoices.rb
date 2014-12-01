class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :account, null: false, index: true
      t.belongs_to :run, null: false, index: true
      t.belongs_to :debits_transaction, null: false, index: true
      t.decimal  "pre_invoice_arrears", null: false
      t.date     "invoice_date", null: false
      t.integer  "property_ref",    null: false
      t.text     "occupiers", null: false
      t.text     "property_address", null: false
      t.text     "billing_address", null: false
      t.text     "client_address", null: false
      t.timestamps
    end
  end
end
