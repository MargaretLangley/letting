class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.belongs_to :invoicing, index: true
      t.timestamps
    end
  end
end
