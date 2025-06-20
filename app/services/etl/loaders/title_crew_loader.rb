# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.crew.tsv.gz file
    class TitleCrewLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.crew.tsv.gz.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.crew.tsv.gz'
      end

      # Process the data loaded from the title.crew.tsv.gz, and loads them to the database. This class loads values for
      # the {#TitleDirector} and {#TitleWriter} models.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
        @loaded_people = loaded_values(Person, :unique_id, read_unique_values(batch, :directors, multivalued: true))
        @loaded_people = @loaded_people.merge(
          loaded_values(Person, :unique_id, read_unique_values(batch, :writers, multivalued: true))
        )
        process_directors(batch)
        process_writers(batch)
      end

      private

      attr_reader :loaded_titles, :loaded_people

      def transform_title_director_row(row, person_id)
        { title_id: loaded_titles[row[:tconst]], person_id: }
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def title_director_data(batch)
        batch.reject { |row| row[:directors] == NULL_VALUE }.each_with_object([]) do |row, array|
          if loaded_titles[row[:tconst]].nil?
            Rails.logger.warn "Title #{row[:tconst]} missing"
            next
          end
          row[:directors].split(',').each do |director|
            if loaded_people[director].nil?
              Rails.logger.warn "Director #{director} missing"
              next
            end
            array << transform_title_director_row(row, loaded_people[director])
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def process_directors(batch)
        TitleDirector.import title_director_data(batch), validate: false, on_duplicate_key_ignore: true
      end

      def transform_title_writer_row(row, person_id)
        { title_id: loaded_titles[row[:tconst]], person_id: }
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def title_writer_data(batch)
        batch.reject { |row| row[:writers] == NULL_VALUE }.each_with_object([]) do |row, array|
          if loaded_titles[row[:tconst]].nil?
            Rails.logger.warn "Title #{row[:tconst]} missing"
            next
          end
          row[:writers].split(',').each do |writer|
            if loaded_people[writer].nil?
              Rails.logger.warn "Writer #{writer} missing"
              next
            end
            array << transform_title_writer_row(row, loaded_people[writer])
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def process_writers(batch)
        TitleWriter.import title_writer_data(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
