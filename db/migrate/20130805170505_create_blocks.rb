class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
