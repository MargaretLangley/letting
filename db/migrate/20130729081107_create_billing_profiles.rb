class CreateBillingProfiles < ActiveRecord::Migration
  def change
    create_table :billing_profiles do |t|
      t.boolean :use_profile, null: false, default: false
      t.integer :property_id, null: false
      t.timestamps
    end
    add_index :billing_profiles, :property_id
  end
end

