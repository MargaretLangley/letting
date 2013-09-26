class CreateDebtGenerators < ActiveRecord::Migration
  def change
    create_table :debt_generators do |t|
      t.string   :search_string, null: false
      t.date     :start_date,    null: false
      t.date     :end_date,    null: false
      t.timestamps
    end
  end
end
