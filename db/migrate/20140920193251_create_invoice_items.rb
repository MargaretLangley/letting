class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.belongs_to :invoice, null: false, index: true
      t.string :charge_type
      t.date :date_due
      t.string :description
      t.decimal :amount
      t.string :range

      t.timestamps
    end
  end
end
