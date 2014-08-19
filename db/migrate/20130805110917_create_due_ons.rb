class CreateDueOns < ActiveRecord::Migration
  def change
    create_table :due_ons do |t|
      t.integer :day, null: false
      t.integer :month, null: false
      t.integer :year
      t.belongs_to :charge_cycle, index: true

      t.timestamps
    end
  end
end
