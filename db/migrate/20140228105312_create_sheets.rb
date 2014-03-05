class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :inv_name
      # t.text :epithet, array: true
      # t.text :line, array: true, default: '{}'
      # t.text :klass, array: true, default: []
      t.timestamps
    end
  end
end


# INSERT INTO sheets VALUES (1, 'Bill',  ARRAY['hello', 'you']);
# INSERT INTO sheets VALUES (2, 'John',  ARRAY['Go', 'away']);