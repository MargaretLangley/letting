class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.integer :entitieable_id, null: false
      t.string  :entitieable_type, null: false
      t.string :title
      t.string :initials
      t.string :name, null: false

      t.timestamps
    end
    add_index :entities, [:entitieable_id, :entitieable_type]
  end
end
