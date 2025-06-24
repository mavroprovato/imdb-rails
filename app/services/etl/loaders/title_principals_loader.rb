# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.principals.tsv.gz file
    class TitlePrincipalsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.principals.tsv.gz.
      #
      # @return [String] Returns title.principals.tsv.gz.
      def filename
        'title.principals.tsv.gz'
      end

      # Process the data loaded from the title.principals.tsv.gz file, and loads them to the database. This class loads
      # values for the {TitlePrincipal} model.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
        @loaded_people = loaded_values(Person, :unique_id, read_unique_values(batch, :nconst))
        load_title_principal_data(batch)
      end

      private

      attr_reader :loaded_titles, :loaded_people

      # Transforms the characters for a principal by cleaning up extra characters.
      #
      # @param characters [String]
      # @return String The cleaned up string.
      def transform_characters(characters)
        characters = transform_nilable_string(characters)
        return nil if characters.nil?

        characters[2...-2].gsub('\"', '"')
      end

      # Transform each input row in order to be loaded into a {TitlePrincipal} model.
      #
      # @param row Hash The data file input row.
      # @return Array[Hash] The transformed data.
      def transform_title_principals_row(row)
        {
          title_id: loaded_titles[row[:tconst]],
          person_id: loaded_people[row[:nconst]],
          ordering: transform_integer(row[:ordering]),
          principal_category: row[:category],
          job: transform_nilable_string(row[:job]),
          characters: transform_characters(row[:characters])
        }
      end

      # Transform the title principal data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def title_principal_data(batch)
        batch.each_with_object([]) do |row, array|
          if loaded_titles[row[:tconst]].nil?
            Rails.logger.warn "Title #{row[:tconst]} not loaded"
            next
          end
          if loaded_people[row[:nconst]].nil?
            Rails.logger.warn "Person #{row[:nconst]} missing"
            next
          end
          array << transform_title_principals_row(row)
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      # Load the {TitlePrincipal} data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_principal_data(batch)
        TitlePrincipal.import title_principal_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: %i[title_id person_id ordering], columns: %i[principal_category job characters]
        }
      end
    end
  end
end
