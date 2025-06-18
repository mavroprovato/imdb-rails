# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.crew.tsv.gz file
    class TitleCrewLoader < BaseLoader
      include LoadHelper

      protected

      attr_reader :loaded_titles, :loaded_people

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.crew.tsv.gz.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.crew.tsv.gz'
      end

      def process_data(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
        @loaded_people = loaded_values(Person, :unique_id, read_unique_values(batch, :directors))
        @loaded_people = @loaded_people.merge(loaded_values(Person, :unique_id, read_unique_values(batch, :writers)))
        process_directors(batch)
      end

      private

      def transform_title_director_row(row, person_id)
        { title_id: loaded_titles[row[:tconst]], person_id: }
      end

      def title_director_data(batch)
        batch.reject { |row| row[:directors] == NULL_VALUE }.each_with_object([]) do |row, array|
          row[:directors].split(',').each do |director|
            array << transform_title_director_row(row, loaded_people[director])
          end
        end
      end

      def process_directors(batch)
        TitleDirector.import title_director_data(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
