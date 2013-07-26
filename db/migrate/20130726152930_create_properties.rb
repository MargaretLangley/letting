class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :human_property_reference

      t.timestamps
    end
  end
end
