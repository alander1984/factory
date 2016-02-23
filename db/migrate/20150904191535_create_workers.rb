class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :fname
      t.string :sname
      t.string :tname
      t.date :birthday
      t.integer :pin

      t.timestamps null: false
    end
  end
end
