class CreateInvoicings < ActiveRecord::Migration
  def change
    create_table :invoicings do |t|

      t.timestamps
    end
  end
end
