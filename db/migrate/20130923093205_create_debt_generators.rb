class CreateDebtGenerators < ActiveRecord::Migration
  def change
    create_table :debt_generators do |t|

      t.timestamps
    end
  end
end
