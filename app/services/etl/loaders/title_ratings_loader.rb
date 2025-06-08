# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.ratings.tsv.gz file
    class TitleRatingsLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # +title.ratings.tsv.gz+.
      #
      # @return [String] Returns title.episode.tsv.gz.
      def filename
        'title.ratings.tsv.gz'
      end

      # Process the data loaded from the +title.ratings.tsv.gzgz+ file, and loads them to the database. This class
      # updates values for the {#Title} model.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        process_title_ratings(batch)
      end

      private

      def process_title_ratings(batch)
        ActiveRecord::Base.connection.execute update_sql(batch)
      end

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
