class AddPhoneToWorker < ActiveRecord::Migration
   def up
  	change_table :workers do |t|
  		t.string :phone
  	end	
  end

  def down
  	remove_column :workers, :phone
  end	
end
