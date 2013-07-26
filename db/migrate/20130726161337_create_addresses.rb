class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :contact, polymorphic: true
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
    add_index :addresses, [:contact_id, :contact_type]
  end
end
