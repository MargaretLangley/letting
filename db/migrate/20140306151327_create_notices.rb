class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :minor,  null: false
      t.string :major,  null: false
      t.string :minor_type,  null: false
      t.string :major_type,  null: false
      t.timestamps
    end
  end
end
