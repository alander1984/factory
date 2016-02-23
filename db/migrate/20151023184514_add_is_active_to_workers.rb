class AddIsActiveToWorkers < ActiveRecord::Migration
  def up
    change_table :workers do |t|
      t.boolean :isactive, :default => true
    end
    Worker.update_all ["isactive = ?", true]
  end
 
  def down
    remove_column :workers, :isactive
  end    
end
