class Initial < ActiveRecord::Migration[8.0]
  def change
    create_table :titles do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.string :type, null: false
      t.string :title, null: false
      t.string :original_title, null: false
      t.boolean :adult, null: false
      t.integer :start_year
      t.integer :end_year
      t.integer :runtime

      t.timestamps
    end

    create_table :people do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :birth_year
      t.integer :death_year

      t.timestamps
    end
  end
end
