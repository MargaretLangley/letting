class CreateBillingProfiles < ActiveRecord::Migration
  def change
    create_table :billing_profiles do |t|
      t.references :property, null: false
      t.timestamps
    end
  end
end
