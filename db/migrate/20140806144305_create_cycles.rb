# Is a one column table good design?
# http://stackoverflow.com/questions/951686/is-a-one-column-table-good-design
#
class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :name, null: false
      t.belongs_to :charged_in, null: false, index: true
      t.integer :order, null: false
      t.string :cycle_type, null: false
      t.integer :due_ons_count, default: 0
      t.timestamps null: true
    end
  end
end
