class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.belongs_to :operation, index: true
      t.belongs_to :worker, index: true
      t.integer :cnt

      t.timestamps null: false
    end
    add_foreign_key :actions, :workers
    add_foreign_key :actions, :operations
  end
end
