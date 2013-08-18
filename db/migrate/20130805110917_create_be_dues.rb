class CreateBeDues < ActiveRecord::Migration
  def change
    create_table :be_dues do |t|
      t.integer :day
      t.integer :month
      t.integer :charge_id

      t.timestamps
    end
    add_index :be_dues, :charge_id
  end
end
