class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :invoice_name,  null: false
      t.string :phone,  null: false
      t.string :vat,  null: false
      t.timestamps
    end
  end
end
