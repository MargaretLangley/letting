class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.boolean :use_profile, null: false, default: false
      t.integer :property_id, null: false
      t.timestamps
    end
    add_index :agents, :property_id
  end
end

