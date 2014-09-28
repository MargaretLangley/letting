class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.belongs_to :template
      t.string :instruction,  null: false
      t.string :fill_in,  null: false
      t.string :sample,  null: false
      t.timestamps
    end
  end
end
