class CreateInvoicings < ActiveRecord::Migration
  def change
    create_table :invoicings do |t|
      t.string "property_range"
      t.timestamps
    end
  end
end
