class CreateDueOns < ActiveRecord::Migration
  def change
    create_table :due_ons do |t|
      t.integer :year
      t.integer :month, null: false
      t.integer :day, null: false
      t.integer :show_month
      t.integer :show_day
      t.belongs_to :cycle, index: true, null: false
      t.timestamps
    end
  end
end
