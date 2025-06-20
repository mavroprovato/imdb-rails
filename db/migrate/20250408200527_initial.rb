# frozen_string_literal: true

# The initial database migration
# rubocop:disable Metrics/AbcSize, Metrics/ClassLength, Metrics/MethodLength
class Initial < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL.squish
      CREATE TYPE title_type AS
      ENUM ('movie', 'short', 'tvEpisode', 'tvMiniSeries', 'tvMovie', 'tvPilot', 'tvSeries', 'tvShort', 'tvSpecial', 'video', 'videoGame');
      CREATE TYPE principal_category AS
      ENUM ('actor', 'actress', 'archive_footage', 'archive_sound', 'casting_director', 'cinematographer', 'composer', 'director', 'editor', 'producer', 'production_designer', 'self', 'writer')
    SQL

    create_table :genres do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :regions do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :languages do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :titles do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.column :title_type, :title_type, null: false
      t.string :title, null: false
      t.string :original_title, null: false
      t.boolean :adult, null: false, default: false
      t.integer :start_year
      t.integer :end_year
      t.integer :runtime
      t.decimal :rating, precision: 3, scale: 1, null: true
      t.integer :votes, null: true

      t.timestamps
    end

    create_table :title_genres do |t|
      t.references :title, null: false, foreign_key: true, index: true
      t.references :genre, null: false, foreign_key: true, index: true

      t.timestamps

      t.index %i[title_id genre_id], unique: true
    end

    create_table :title_aliases do |t|
      t.references :title, null: false, foreign_key: true
      t.references :region, foreign_key: true
      t.references :language, foreign_key: true

      t.integer :ordering, null: false
      t.string :name, null: false
      t.string :alias_types, array: true, null: false, default: []
      t.string :extra_attribute
      t.boolean :original_title, null: false, default: true

      t.timestamps

      t.index %i[title_id ordering], unique: true
    end

    create_table :people do |t|
      t.string :unique_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :birth_year
      t.integer :death_year

      t.timestamps
    end

    create_table :professions do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :person_primary_professions do |t|
      t.references :person, null: false, foreign_key: true
      t.references :profession, null: false, foreign_key: true

      t.timestamps

      t.index %i[person_id profession_id], unique: true
    end

    create_table :person_known_for_titles do |t|
      t.references :person, null: false, foreign_key: true
      t.references :title, null: false, foreign_key: true

      t.timestamps

      t.index %i[person_id title_id], unique: true
    end

    create_table :title_episodes do |t|
      t.references :title, null: false, foreign_key: true
      t.references :parent_title, null: false, foreign_key: { to_table: :titles }
      t.integer :season, null: true
      t.integer :episode, null: true

      t.timestamps
    end

    create_table :title_directors do |t|
      t.references :person, null: false, foreign_key: true
      t.references :title, null: false, foreign_key: true

      t.timestamps

      t.index %i[person_id title_id], unique: true
    end

    create_table :title_writers do |t|
      t.references :title, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps

      t.index %i[title_id person_id], unique: true
    end

    create_table :title_principals do |t|
      t.references :title, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.integer :ordering, null: false
      t.column :principal_category, :principal_category, null: false
      t.string :job
      t.string :characters

      t.timestamps

      t.index %i[title_id person_id ordering], unique: true
      t.check_constraint 'ordering >= 1'
    end
  end

  def down
    drop_table :title_principals
    drop_table :title_writers
    drop_table :title_directors
    drop_table :title_episodes
    drop_table :person_primary_professions
    drop_table :professions
    drop_table :people
    drop_table :title_genres
    drop_table :titles
    drop_table :languages
    drop_table :regions
    drop_table :genres
    execute <<~SQL.squish
      DROP TYPE title_type;
      DROP TYPE principal_category;
    SQL
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/ClassLength, Metrics/MethodLength
