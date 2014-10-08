class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.belongs_to :invoice, null: false, index: true
      t.belongs_to :template, null: false, index: true

      t.timestamps
    end
  end
end
