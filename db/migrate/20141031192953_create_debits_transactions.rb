class CreateDebitsTransactions < ActiveRecord::Migration
  def change
    create_table :debits_transactions do |t|

      t.timestamps
    end
  end
end
