class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :description,  null: false
      t.string :invoice_name,  null: false
      t.string :phone,  null: false
      t.string :vat,  null: false
      t.string :heading1
      t.string :heading2
      t.text :advice1
      t.text :advice2
      t.timestamps
    end
  end
end
