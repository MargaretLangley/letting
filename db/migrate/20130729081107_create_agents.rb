class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.boolean :use_profile, null: false, default: false
      t.integer :property_id, null: false, index: true
      t.timestamps
    end
  end
end

