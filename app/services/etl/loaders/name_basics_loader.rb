# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the name.basics.tsv.gz file
    class NameBasicsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # name.basics.tsv.gz.
      #
      # @return String Returns name.basics.tsv.gz.
      def filename
        'name.basics.tsv.gz'
      end

      # Process the data loaded from the name.basics.tsv.gz file, and loads them to the database. This class loads
      # values for the {#Profession}, {#Person}, {#PersonPrimaryProfession} and {#PersonKnownForTitle} models.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        load_professions(batch)
        load_people(batch)
        load_primary_professions(batch)
        load_person_known_for_title(batch)
      end

      private

      attr_reader :loaded_professions, :loaded_people, :loaded_titles

      # Transform the profession data.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The transformed profession data.
      def transform_profession_data(batch)
        read_unique_values(batch, :primaryProfession, multivalued: true).each_with_object([]) do |name, array|
          array << { name: }
        end
      end

      # Load the +Profession+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_professions(batch)
        Profession.import transform_profession_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_professions = loaded_values(
          Profession, :name, read_unique_values(batch, :primaryProfession, multivalued: true)
        )
      end

      # Transform each input row from the data file in order to be loaded into a +Person+ model.
      #
      # @param row Hash The data file input row.
      # @return Hash The transformed data.
      def transform_person_row(row)
        {
          unique_id: row[:nconst],
          name: row[:primaryName],
          birth_year: transform_nilable_integer(row[:birthYear]),
          death_year: transform_nilable_integer(row[:deathYear])
        }
      end

      # Transform the person data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_person_data(batch)
        batch.map { |row| transform_person_row(row) }
      end

      # Load the +Person+ data to the database.
      #
      # @param batch Array[Hash] The data to load.
      def load_people(batch)
        Person.import transform_person_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id], columns: %i[name birth_year death_year]
        }
        @loaded_people = loaded_values(Person, :unique_id, read_unique_values(batch, :nconst))
      end

      # Transform each input row in order to be loaded into a +PersonPrimaryProfession+ model.
      #
      # @param row Hash The data to load.
      # @return Array[Hash] The transformed data.
      def transform_person_primary_profession_row(row)
        row[:primaryProfession].split(',').each_with_object([]) do |profession, array|
          array << { person_id: loaded_people[row[:nconst]], profession_id: loaded_professions[profession] }
        end
      end

      # Transform the person primary profession data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_person_primary_professions(batch)
        batch.reject { |row| row[:primaryProfession] == NULL_VALUE }.each_with_object([]) do |row, array|
          array.concat transform_person_primary_profession_row(row)
        end
      end

      # Load the +PersonPrimaryProfession+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_primary_professions(batch)
        PersonPrimaryProfession.import transform_person_primary_professions(batch), validate: false,
                                                                                    on_duplicate_key_ignore: true
      end

      # Transform each input row in order to be loaded into a +PersonKnownForTitle+ model.
      #
      # @param row Hash The data file input row.
      # @return Array[Hash] The transformed data.
      def transform_person_known_for_title_row(row)
        row[:knownForTitles].split(',').each_with_object([]) do |title, array|
          if loaded_titles[title].nil?
            Rails.logger.warn "Title #{title} not loaded"
            next
          end
          array << { person_id: loaded_people[row[:nconst]], title_id: loaded_titles[title] }
        end
      end

      # Transform the person known for title data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_person_known_for_title(batch)
        batch.reject { |row| row[:knownForTitles] == NULL_VALUE }.each_with_object([]) do |row, array|
          array.concat transform_person_known_for_title_row(row)
        end
      end

      # Load the +PersonKnownForTitle+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_person_known_for_title(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :knownForTitles, multivalued: true))
        PersonKnownForTitle.import transform_person_known_for_title(batch), validate: false,
                                                                            on_duplicate_key_ignore: true
      end
    end
  end
end
