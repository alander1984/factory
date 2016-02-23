class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.belongs_to :workshop, index: true
      t.string :name
      t.integer :special
      t.timestamps null: false
    end
    add_foreign_key :operations, :workshops

  end
end
