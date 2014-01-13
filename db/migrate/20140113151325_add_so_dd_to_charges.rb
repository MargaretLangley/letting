class AddSoDdToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :so_dd, :boolean
  end
end
