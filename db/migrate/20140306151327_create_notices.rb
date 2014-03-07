class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :notice_head,  null: false
      t.string :notice_body,  null: false
      t.string :notice_type,  null: false
      t.timestamps
    end
  end
end
