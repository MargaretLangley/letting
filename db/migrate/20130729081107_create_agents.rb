class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.boolean :authorized, null: false, default: false
      t.belongs_to :property, null: false, index: true
      t.timestamps
    end
  end
end

