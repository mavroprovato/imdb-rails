# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.episode.tsv.gz file
    class TitleEpisodeLoader < BaseLoader
      # The title of the columns which contain titles
      TITLE_COLUMN_NAMES = %i[tconst parentTconst].freeze

      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.episode.tsv.gz.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.episode.tsv.gz'
      end

      # Process the data loaded from the title.episode.tsv.gz file, and loads them to the database. This class loads
      # values for the {#TitleEpisode} model.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        load_title_episodes(batch)
      end

      private

      attr_reader :loaded_titles

      # Transform each input row from the data file in order to be loaded into a +TitleEpisode+ model.
      #
      # @param row Hash The data file input row.
      # @return Hash The transformed data.
      def transform_title_episode_row(row)
        {
          title_id: loaded_titles[row[:tconst]],
          parent_title_id: loaded_titles[row[:parentTconst]],
          season: transform_nilable_integer(row[:seasonNumber]),
          episode: transform_nilable_integer(row[:episodeNumber])
        }
      end

      # Transform the title episode data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def transform_title_episodes(batch)
        batch.each_with_object([]) do |row, array|
          title_missing = false
          TITLE_COLUMN_NAMES.each do |column|
            if loaded_titles[row[column]].nil?
              Rails.logger.warn "Title #{row[column]} not loaded"
              title_missing = true
            end
          end
          array << transform_title_episode_row(row) unless title_missing
        end
      end

      # Load the +TitleEpisode+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_episodes(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :tconst))
                         .merge(loaded_values(Title, :unique_id, read_unique_values(batch, :parentTconst)))
        TitleEpisode.import transform_title_episodes(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
