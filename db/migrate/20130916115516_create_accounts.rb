class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :property, index: true, null: false
      t.timestamps null: true
    end
  end
end
