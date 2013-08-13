class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :human_id

      t.timestamps
    end
  end
end
