class CreateSearchSuggestions < ActiveRecord::Migration
  def change
    create_table :search_suggestions do |t|
      t.string :term, null: false
      t.integer :popularity, null: false

      t.timestamps null: true
    end
  end
end
