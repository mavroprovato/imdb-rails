class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :birth_year
      t.integer :death_year

      t.timestamps
    end
  end
end
