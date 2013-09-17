class CreateAccountEntries < ActiveRecord::Migration
  def change
    create_table :account_entries do |t|
      t.string :account_id, null: false
      t.string :charge_id, null: false
      t.string :on_date, null: false
      t.decimal :due, precision: 8, scale: 2, null: false
      t.decimal :paid, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :account_entries, :account_id
  end
end
