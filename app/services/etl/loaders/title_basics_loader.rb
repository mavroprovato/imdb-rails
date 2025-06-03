# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the title.basics.tsv.gz file
    class TitleBasicsLoader < BaseLoader
      protected

      def filename
        'title.basics.tsv.gz'
      end

      def process_data(batch)
        process_genres(batch)
        process_titles(batch)
        process_title_genres(batch)
      end

      private

      attr_reader :loaded_genres, :loaded_titles

      def process_genres(batch)
        Genre.import genre_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_genres = load_genres(batch)
      end

      def read_genres(batch)
        batch.each_with_object(Set.new) do |row, set|
          next if row[:genres] == '\N'

          row[:genres].split(',').each { |name| set << name }
        end
      end

      def genre_data(batch)
        read_genres(batch).each_with_object([]) { |name, array| array << { name: } }
      end

      def load_genres(batch)
        Genre.where(name: read_genres(batch)).pluck(:id, :name).each_with_object({}) do |(id, name), hash|
          hash[name] = id
        end
      end

      def process_titles(batch)
        Title.import title_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id],
          columns: %i[title_type title original_title adult start_year end_year runtime]
        }
        @loaded_titles = load_titles(batch)
      end

      def transform_title_row(row)
        {
          unique_id: row[:tconst],
          title_type: row[:titleType],
          title: row[:primaryTitle],
          original_title: row[:originalTitle],
          adult: row[:isAdult] == '1',
          start_year: row[:startYear] == '\N' ? nil : row[:startYear].to_i,
          end_year: row[:endYear] == '\N' ? nil : row[:endYear].to_i,
          runtime: row[:runtimeMinutes].to_i == '\N' ? nil : row[:runtimeMinutes].to_i
        }
      end

      def title_data(batch)
        batch.map { |row| transform_title_row(row) }
      end

      def load_titles(batch)
        Title.where(
          unique_id: batch.map { |row| row[:tconst] }
        ).pluck(:id, :unique_id).each_with_object({}) { |(id, unique_id), hash| hash[unique_id] = id }
      end

      def title_genre_data(batch)
        batch.each_with_object([]) do |row, array|
          next if row[:genres] == '\N'

          row[:genres].split(',') do |genre|
            array << { title_id: loaded_titles[row[:tconst]], genre_id: loaded_genres[genre] }
          end
        end
      end

      def process_title_genres(batch)
        TitleGenre.import title_genre_data(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
