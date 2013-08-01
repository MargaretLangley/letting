class CreateBillingProfiles < ActiveRecord::Migration
  def change
    create_table :billing_profiles do |t|
      t.boolean :use_profile, null: false, default: false
      t.references :property, null: false
      t.timestamps
    end
  end
end

