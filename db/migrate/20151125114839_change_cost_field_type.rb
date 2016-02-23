class ChangeCostFieldType < ActiveRecord::Migration
  def up
  	change_column :operation_costs, :cost, :float
  end

  def down
  	change_column :operation_costs, :cost, :integer
  end

end
