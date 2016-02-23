class AddIsActiveToWorkshop < ActiveRecord::Migration
  def up
    change_table :workshops do |t|
      t.boolean :isactive, :default => true
    end
    Workshop.update_all ["isactive = ?", true]
  end
 
  def down
    remove_column :workshops, :isactive
  end    
end
