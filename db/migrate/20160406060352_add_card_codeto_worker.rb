class AddCardCodetoWorker < ActiveRecord::Migration
  def up
  	change_table :workers do |t|
  		t.string :cardcode
  	end	
  end

  def down
  	remove_column :workers, :cardcode
  end	
end
