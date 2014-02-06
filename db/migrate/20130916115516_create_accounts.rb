class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :property, index: true
      t.timestamps
    end
  end
end
