# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.basics.tsv.gz file
    class TitleBasicsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.basics.tsv.gz.
      #
      # @return [String] Returns title.basics.tsv.gz.
      def filename
        'title.basics.tsv.gz'
      end

      # Process the data loaded from the title.basics.tsv.gz file, and loads them to the database. This class loads
      # values for the {#Genre}, {#Title} and {#TitleGenre} models.
      #
      # @param batch Array[Hash] The batch data.
      def process_data(batch)
        load_genres(batch)
        load_titles(batch)
        load_title_genres(batch)
      end

      private

      attr_reader :loaded_genres, :loaded_titles

      # Transform the genre data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The transformed genre data.
      def transform_genres(batch)
        read_unique_values(batch, :genres, multivalued: true).each_with_object([]) { |name, array| array << { name: } }
      end

      # Load the +Genre+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_genres(batch)
        Genre.import transform_genres(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_genres = loaded_values(Genre, :name, read_unique_values(batch, :genres, multivalued: true))
      end

      # Transform each input row from the data file in order to be loaded into a +Title+ model.
      #
      # @param row Hash The data file input row.
      # @return Hash The transformed data.
      def transform_title_row(row)
        {
          unique_id: row[:tconst],
          title_type: row[:titleType],
          title: row[:primaryTitle],
          original_title: row[:originalTitle],
          adult: transform_boolean?(row[:isAdult]),
          start_year: transform_nilable_integer(row[:startYear]),
          end_year: transform_nilable_integer(row[:endYear]),
          runtime: transform_nilable_integer(row[:runtimeMinutes])
        }
      end

      # Transform the title data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_titles(batch)
        batch.map { |row| transform_title_row(row) }
      end

      # Load the +Title+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_titles(batch)
        Title.import transform_titles(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id],
          columns: %i[title_type title original_title adult start_year end_year runtime]
        }
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
      end

      # Transform each input row from the data file in order to be loaded into a +TitleGenre+ model.
      #
      # @param row Hash The data file input row.
      # @return Array[Hash] The transformed data.
      def transform_title_genre_row(row)
        row[:genres].split(',').each_with_object([]) do |genre, array|
          array << { title_id: loaded_titles[row[:tconst]], genre_id: loaded_genres[genre] }
        end
      end

      # Transform the title genre data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_title_genres(batch)
        batch.reject { |row| row[:genres] == NULL_VALUE }.each_with_object([]) do |row, array|
          array.concat transform_title_genre_row(row)
        end
      end

      # Load the +TitleGenre+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_genres(batch)
        TitleGenre.import transform_title_genres(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
