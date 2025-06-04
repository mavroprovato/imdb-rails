# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the name.basics.tsv.gz file
    class NameBasicsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # +name.basics.tsv.gz+.
      #
      # @return String Returns name.basics.tsv.gz.
      def filename
        'name.basics.tsv.gz'
      end

      # Process the data loaded from the +name.basics.tsv.gz+ file, and loads them to the database. This class loads
      # values for the {#Profession}, {#Person}, {#PersonPrimaryProfession} and {#PersonKnownForTitle} models.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        process_professions(batch)
        process_people(batch)
        process_primary_professions(batch)
        process_person_known_for_title(batch)
      end

      private

      attr_reader :loaded_professions, :loaded_people, :loaded_titles

      def profession_data(batch)
        read_unique_values(batch, :primaryProfession, multivalued: true).each_with_object([]) do |name, array|
          array << { name: }
        end
      end

      def process_professions(batch)
        Profession.import profession_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_professions = loaded_values(
          Profession, :name, read_unique_values(batch, :primaryProfession, multivalued: true)
        )
      end

      def transform_person_row(row)
        {
          unique_id: row[:nconst],
          name: row[:primaryName],
          birth_year: transform_nilable_integer(row[:birthYear]),
          death_year: transform_nilable_integer(row[:deathYear])
        }
      end

      def person_data(batch)
        batch.map { |row| transform_person_row(row) }
      end

      def process_people(batch)
        Person.import person_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id], columns: %i[name birth_year death_year]
        }
        @loaded_people = loaded_values(Person, :unique_id, read_unique_values(batch, :nconst))
      end

      def person_primary_profession_data(batch)
        batch.reject { |row| row[:primaryProfession] == NULL_VALUE }.each_with_object([]) do |row, array|
          row[:primaryProfession].split(',').map do |profession|
            array << { person_id: loaded_people[row[:nconst]], profession_id: loaded_professions[profession] }
          end
        end
      end

      def process_primary_professions(batch)
        PersonPrimaryProfession.import person_primary_profession_data(batch), validate: false,
                                                                              on_duplicate_key_ignore: true
      end

      def process_person_known_for_title(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :knownForTitles, multivalued: true))
        PersonKnownForTitle.import person_known_for_title_data(batch), validate: false,
                                                                       on_duplicate_key_ignore: true
      end

      def transform_person_known_for_title_row(row, title_id)
        { person_id: loaded_people[row[:nconst]], title_id: }
      end

      def person_known_for_title_data(batch)
        batch.reject { |row| row[:knownForTitles] == NULL_VALUE }.each_with_object([]) do |row, array|
          row[:knownForTitles].split(',').each do |title|
            if loaded_titles[title].nil?
              Rails.logger.warn "Title #{title} not loaded"
              next
            end
            array << transform_person_known_for_title_row(row, loaded_titles[title])
          end
        end
      end
    end
  end
end
