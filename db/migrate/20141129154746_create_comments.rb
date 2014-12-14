class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :invoice, index: true, null: false
      t.string :clarify, null: false

      t.timestamps
    end
  end
end
