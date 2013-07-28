class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.integer :entitieable_id
      t.string  :entitieable_type
      t.string :title
      t.string :initials
      t.string :name

      t.timestamps
    end
    add_index :entities, [:entitieable_id, :entitieable_type]
  end
end
