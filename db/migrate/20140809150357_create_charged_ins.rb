class CreateChargedIns < ActiveRecord::Migration
  def change
    create_table :charged_ins do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
