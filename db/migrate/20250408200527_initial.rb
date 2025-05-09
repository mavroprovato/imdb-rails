# frozen_string_literal: true

class Initial < ActiveRecord::Migration[8.0]
  def change
    execute <<~SQL
      CREATE TYPE title_type AS
      ENUM ('movie', 'short', 'tvEpisode', 'tvMiniSeries', 'tvMovie', 'tvPilot', 'tvSeries', 'tvShort', 'tvSpecial', 'video', 'videoGame');
    SQL

    create_table :genres do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :titles do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.column :title_type, :title_type, null: false
      t.string :title, null: false
      t.string :original_title, null: false
      t.boolean :adult, null: false
      t.integer :start_year
      t.integer :end_year
      t.integer :runtime, null: false

      t.timestamps
    end

    create_table :title_genres, primary_key: [ :title_id, :genre_id ] do |t|
      t.references :title, null: false, foreign_key: true, index: true
      t.references :genre, null: false, foreign_key: true, index: true

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
