class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.belongs_to :invoice_text, null: false, index: true
      t.text :instruction, null: false
      t.text :fillin, null: false
      t.text :sample, null: false
      t.timestamps
    end
  end
end
