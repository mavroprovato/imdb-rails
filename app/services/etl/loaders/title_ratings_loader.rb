# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.ratings.tsv.gz file
    class TitleRatingsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.ratings.tsv.gz.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.ratings.tsv.gz'
      end

      # Process the data loaded from the title.ratings.tsv.gz file, and loads them to the database. This class
      # updates values for the {#Title} model.
      #
      # @param batch Array[Hash] The batch data.
      def process_data(batch)
        load_title_ratings(batch)
      end

      private

      # Load the title ratings. It updates the ratings column for existing titles in the database.
      def load_title_ratings(batch)
        ActiveRecord::Base.connection.execute update_sql(batch)
      end

      # The update SQL needed to update ratings for titles
      #
      # @param batch Array[Hash] The batch data.
      # @return String The update SQL
      def update_sql(batch)
        values = batch.map { |row| "('#{row[:tconst]}', #{row[:averageRating]}, #{row[:numVotes]})" }.join(',')
        <<~SQL.squish
          UPDATE titles
          SET rating = title_ratings_insert.rating, votes = title_ratings_insert.votes, updated_at = NOW()
          FROM (VALUES #{values}) AS title_ratings_insert(unique_id, rating, votes)
          WHERE titles.unique_id = title_ratings_insert.unique_id;
        SQL
      end
    end
  end
end
