# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.crew.tsv.gz file
    class TitleCrewLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # `title.crew.tsv.gz`.
      #
      # @return [String] Returns title.crew.tsv.gz.
      def filename
        'title.crew.tsv.gz'
      end

      # Process the data loaded from the title.crew.tsv.gz, and loads them to the database. This class loads values for
      # the {TitleDirector} and {TitleWriter} models.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
        @loaded_people =
          loaded_values(Person, :unique_id, read_unique_values(batch, :directors, multivalued: true))
          .merge(loaded_values(Person, :unique_id, read_unique_values(batch, :writers, multivalued: true)))
        load_title_directors(batch)
        load_title_writers(batch)
      end

      private

      attr_reader :loaded_titles, :loaded_people

      # Transform each input row in order to be loaded into a {TitleDirector} model.
      #
      # @param row Hash The data file input row.
      # @return Array[Hash] The transformed data.
      def transform_title_director_row(row)
        row[:directors].split(',').each_with_object([]) do |name, array|
          if loaded_people[name].nil?
            Rails.logger.warn "Person #{name} not loaded"
            next
          end
          array << { title_id: loaded_titles[row[:tconst]], person_id: loaded_people[name] }
        end
      end

      # Transform the title director data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def title_director_data(batch)
        batch.reject { |row| row[:directors] == NULL_VALUE }.each_with_object([]) do |row, array|
          if loaded_titles[row[:tconst]].nil?
            Rails.logger.warn "Title #{row[:tconst]} not loaded"
            next
          end
          array.concat transform_title_director_row(row)
        end
      end

      # Load the {TitleDirector} data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_directors(batch)
        TitleDirector.import title_director_data(batch), validate: false, on_duplicate_key_ignore: true
      end

      # Transform each input row in order to be loaded into a {TitleWriter} model.
      #
      # @param row Hash The data file input row.
      # @return Array[Hash] The transformed data.
      def transform_writer_director_row(row)
        row[:writers].split(',').each_with_object([]) do |name, array|
          if loaded_people[name].nil?
            Rails.logger.warn "Person #{name} not loaded"
            next
          end
          array << { title_id: loaded_titles[row[:tconst]], person_id: loaded_people[name] }
        end
      end

      # Transform the title writer data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def title_writer_data(batch)
        batch.reject { |row| row[:writers] == NULL_VALUE }.each_with_object([]) do |row, array|
          if loaded_titles[row[:tconst]].nil?
            Rails.logger.warn "Title #{row[:tconst]} not loaded"
            next
          end
          array.concat transform_writer_director_row(row)
        end
      end

      # Load the {TitleWriter} data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_writers(batch)
        TitleWriter.import title_writer_data(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
