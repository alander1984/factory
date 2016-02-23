class CreateWorkshops < ActiveRecord::Migration
  def change
    create_table :workshops do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
