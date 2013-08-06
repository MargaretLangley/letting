class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name, null: false
      t.integer :client_id, null: false

      t.timestamps
    end
    add_index :blocks, :client_id
  end
end
