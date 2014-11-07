class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.belongs_to :template, null: false, index: true
      t.string :instruction, array: true, default: []
      t.string :fillin, array: true, default: []
      t.string :sample, array: true, default: []
      t.timestamps
    end
  end
end
