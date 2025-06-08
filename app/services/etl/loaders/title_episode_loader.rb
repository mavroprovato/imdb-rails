# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.episode.tsv.gz file
    class TitleEpisodeLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # +title.episode.tsv.gz+.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.episode.tsv.gz'
      end

      # Process the data loaded from the +title.episode.tsv.gz+ file, and loads them to the database. This class loads
      # values for the {#TitleEpisode} model.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        process_title_episodes(batch)
      end

      private

      attr_reader :loaded_titles

      def process_title_episodes(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
                         .merge(loaded_values(Title, :unique_id, read_unique_values(batch, :parentTconst)))
        TitleEpisode.import title_episode_data(batch), validate: false, on_duplicate_key_ignore: true
      end

      def transform_title_episode_row(row)
        {
          title_id: loaded_titles[row[:tconst]],
          parent_title_id: loaded_titles[row[:parentTconst]],
          season: transform_integer(row[:seasonNumber]),
          episode: transform_integer(row[:episodeNumber])
        }
      end

      def title_episode_data(batch)
        title_column_names = %i[tconst parentTconst]
        batch.each_with_object([]) do |row, array|
          title_column_names.each do |column|
            if loaded_titles[row[column]].nil?
              Rails.logger.warn "Title #{row[column]} not loaded"
              next
            end
          end
          array << transform_title_episode_row(row)
        end
      end
    end
  end
end

