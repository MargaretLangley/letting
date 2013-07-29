class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :flat_no
      t.string :house_name
      t.string :road_no
      t.string :road
      t.string :district
      t.string :town
      t.string :county
      t.string :postcode

      t.timestamps
    end
    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
