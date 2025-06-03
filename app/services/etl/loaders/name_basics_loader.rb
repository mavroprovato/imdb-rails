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

      attr_reader :loaded_professions, :loaded_people

      def read_professions(batch)
        batch.reject { |row| row[:primaryProfession] == NULL_VALUE }.each_with_object(Set.new) do |row, set|
          row[:primaryProfession].split(',').each { |name| set << name }
        end
      end

      def profession_data(batch)
        read_professions(batch).each_with_object([]) { |name, array| array << { name: } }
      end

      def process_professions(batch)
        Profession.import profession_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_professions = load_professions(batch)
      end

      def load_professions(batch)
        Profession.where(name: read_professions(batch)).pluck(:id, :name).each_with_object({}) do |(id, name), hash|
          hash[name] = id
        end
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

      def load_people(batch)
        Person.where(
          unique_id: batch.map { |row| row[:nconst] }
        ).pluck(:id, :unique_id).each_with_object({}) { |(id, unique_id), hash| hash[unique_id] = id }
      end

      def process_people(batch)
        Person.import person_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id], columns: %i[name birth_year death_year]
        }
        @loaded_people = load_people(batch)
      end

      def process_primary_professions(batch)
        PersonPrimaryProfession.import person_primary_profession_data(batch), validate: false,
                                                                              on_duplicate_key_ignore: true
      end

      def person_primary_profession_data(batch)
        batch.reject { |row| row[:primaryProfession] == NULL_VALUE }.each_with_object([]) do |row, array|
          row[:primaryProfession].split(',').map do |profession|
            array << { person_id: loaded_people[row[:nconst]], profession_id: loaded_professions[profession] }
          end
        end
      end

      def unique_titles(batch)
        batch.reject { |row| row[:knownForTitles] == NULL_VALUE }.each_with_object(Set.new) do |row, set|
          row[:knownForTitles].split(',').each { |name| set << name }
        end
      end

      def load_titles(batch)
        Title.where(unique_id: unique_titles(batch)).pluck(:id, :unique_id)
             .each_with_object({}) do |(id, unique_id), hash|
          hash[unique_id] = id
        end
      end

      def person_known_for_title_data(batch)
        title_ids = load_titles(batch)
        batch.reject { |row| row[:knownForTitles] == NULL_VALUE }.each_with_object([]) do |row, array|
          row[:knownForTitles].split(',').each do |title|
            if title_ids[title].nil?
              Rails.logger.warn "Title #{title} not loaded"
              next
            end
            array << { person_id: loaded_people[row[:nconst]], title_id: title_ids[title] }
          end
        end
      end

      def process_person_known_for_title(batch)
        PersonKnownForTitle.import person_known_for_title_data(batch), validate: false,
                                                                       on_duplicate_key_ignore: true
      end
    end
  end
end
