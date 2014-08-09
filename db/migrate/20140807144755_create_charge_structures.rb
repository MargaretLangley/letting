class CreateChargeStructures < ActiveRecord::Migration
  def change
    create_table :charge_structures do |t|
      t.references :charged_ins
      t.references :charge_cycle

      t.timestamps
    end
  end
end
