class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :human_property_id
      t.integer :client_id
      t.timestamps
    end

    add_index, :properties, :client_id
  end
end
