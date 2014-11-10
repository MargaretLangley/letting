class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.belongs_to :template, null: false, index: true
      t.text :instruction
      t.text :fillin
      t.text :sample
      t.timestamps
    end
  end
end
