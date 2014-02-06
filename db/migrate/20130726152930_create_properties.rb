class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :human_ref, null: false
      t.integer :client_id, index: true
      t.timestamps
    end
  end
end
