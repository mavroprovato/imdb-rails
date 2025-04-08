class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :unique_id
      t.string :name
      t.integer :birth_year
      t.integer :death_year

      t.timestamps
    end
  end
end
