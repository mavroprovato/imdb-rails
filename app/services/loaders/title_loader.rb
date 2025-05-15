# frozen_string_literal: true

module Loaders
  class TitleLoader < BaseLoader
    protected

    def filename
      "title.basics.tsv.gz"
    end

    def process_data(batch)
      Title.import title_data(batch), validate: false, on_duplicate_key_update: {
        conflict_target: [ :unique_id ],
        columns: [ :title_type, :title, :original_title, :adult, :start_year, :end_year, :runtime ]
      }
      TitleGenre.import title_genre_data(batch), validate: false, on_duplicate_key_ignore: true
    end

    private

    def title_data(batch)
      batch.map do |row|
        {
          unique_id: row[0],
          title_type: row[1],
          title: row[2],
          original_title: row[3],
          adult: row[4] == "1",
          start_year: row[5] == '\N' ? nil : row[5].to_i,
          end_year: row[6] == '\N' ? nil : row[6].to_i,
          runtime: row[7].to_i
        }
      end
    end

    def titles(batch)
      Title.where(
        unique_id: batch.map { |row| row[0] }
      ).pluck(:id, :unique_id).each_with_object({}) { |(id, unique_id), hash| hash[unique_id] = id }
    end

    def genres
      @genres ||= Genre.pluck(:id, :name).each_with_object({}) { |(id, name), hash| hash[name] = id }
    end

    def title_genre_data(batch)
      title_map = titles(batch)
      batch.each_with_object([]) do |row, array|
        next if row[8].chomp == '\N'

        array << row[8].chomp.split(",").map { |name| { title_id: title_map[row[0]], genre_id: genres[name] } }
      end.flatten
    end
  end
end
