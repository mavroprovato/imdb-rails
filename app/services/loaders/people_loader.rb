# frozen_string_literal: true

module Loaders
  # Loads people to the database
  class PeopleLoader < BaseLoader
    def filename
      "name.basics.tsv.gz"
    end

    def process_data(batch)
      Person.import person_data(batch), validate: false, on_duplicate_key_update: {
        conflict_target: [:unique_id], columns: %i[name birth_year death_year]
      }
    end

    private

    def person_data(batch)
      batch.map { |row| transform_row(row) }
    end

    def transform_row(row)
      {
        unique_id: row[0],
        name: row[1],
        birth_year: row[2] == '\N' ? nil : row[2].to_i,
        death_year: row[3] == '\N' ? nil : row[3].to_i
      }
    end
  end
end
