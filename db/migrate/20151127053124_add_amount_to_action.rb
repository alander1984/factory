class AddAmountToAction < ActiveRecord::Migration
  def up
    change_table :actions do |t|
      t.float :amount, :default => 0
    end
    Action.update_all ["amount = 0", 0]
  end
 
  def down
    remove_column :actions, :amount
  end    end
