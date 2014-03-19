class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.belongs_to :sheet, index: true
      t.string :instruction,  null: false
      t.string :clause,  null: false
      t.string :proxy,  null: false
      t.timestamps
    end
  end
end
