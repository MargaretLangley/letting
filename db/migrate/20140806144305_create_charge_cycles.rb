# Is a one column table good design?
# http://stackoverflow.com/questions/951686/is-a-one-column-table-good-design
#
class CreateChargeCycles < ActiveRecord::Migration
  def change
    create_table :charge_cycles do |t|
      t.string :name
      t.timestamps
    end
  end
end
