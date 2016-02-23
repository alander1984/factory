class AddIsActiveToOperation < ActiveRecord::Migration
  def up
    change_table :operations do |t|
      t.boolean :isactive, :default => true
    end
    Operation.update_all ["isactive = ?", true]
  end
 
  def down
    remove_column :operations, :isactive
  end    
end
