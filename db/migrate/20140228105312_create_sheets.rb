class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :invoice_name
      t.timestamps
    end
  end
end
