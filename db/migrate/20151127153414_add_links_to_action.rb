class AddLinksToAction < ActiveRecord::Migration
 
  def up
  	change_table :actions do |t|
  		t.integer :linkedoperation_id, :references => "operation"
  		t.integer :linkedworker_id, :references => "worker"
  	end	
	add_foreign_key :actions, :operations, column: :linkedoperation_id
	add_foreign_key :actions, :workers, column: :linkedworker_id
  end

  def down
  	remove_column :actions, :linkedoperation_id
  	remove_column :actions, :linkedworker_id
  end	
#		belongs_to :operation, foreign_key: "linkedoperation_id"
#		belongs_to :worker, foreign_key: "linkedworker_id"

end
