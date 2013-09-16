class CreateAccountEntries < ActiveRecord::Migration
  def change
    create_table :account_entries do |t|
      t.string :account_id, null: false
      t.string :charge_id, null: false
      t.string :on_date, null: false
      t.string :due
      t.string :paid

      t.timestamps
    end

    add_index :account_entries, :account_id
  end
end
