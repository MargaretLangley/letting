class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :human_property_id

      t.timestamps
    end
  end
end
