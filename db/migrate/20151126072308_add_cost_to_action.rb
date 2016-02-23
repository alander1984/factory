class AddCostToAction < ActiveRecord::Migration
  def up
    change_table :actions do |t|
      t.float :cost, :default => 0
    end
    Action.update_all ["cost = 0", 0]
  end
 
  def down
    remove_column :actions, :cost
  end    
end
