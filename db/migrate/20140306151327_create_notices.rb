class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.belongs_to :sheet, index: true
      t.string :instruction
      t.string :clause
      t.string :proxy
      t.timestamps
    end
  end
end
