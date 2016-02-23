class AddOperationCost < ActiveRecord::Migration
  def up
    create_table :operation_costs do |t|
      t.date :sdate
      t.date :edate
      t.integer :cost
      t.belongs_to :operation, index: true
    end
    add_foreign_key :operation_costs, :operations 
  end
  
  
  def down
    drop_table :operation_costs
  end
end
