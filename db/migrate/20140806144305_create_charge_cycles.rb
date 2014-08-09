class CreateChargeCycles < ActiveRecord::Migration
  def change
    create_table :charge_cycles do |t|
      t.string :name
      t.timestamps
    end
  end
end
