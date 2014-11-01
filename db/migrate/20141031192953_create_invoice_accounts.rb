class CreateInvoiceAccounts < ActiveRecord::Migration
  def change
    create_table :invoice_accounts do |t|

      t.timestamps
    end
  end
end
