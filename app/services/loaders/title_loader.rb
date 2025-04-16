# frozen_string_literal: true

module Loaders
  class TitleLoader < BaseLoader
    def load_data
      puts "Loading title data..."
      read_batch(Downloader.new(filename).download) do |batch|
        Title.import title_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [ :unique_id ],
          columns: [ :type, :title, :original_title, :adult, :start_year, :end_year, :runtime ]
        }
      end
      puts "Title data loaded"
    end

    protected

    def filename
      "title.basics.tsv.gz"
    end

    private

    def title_data(batch)
      batch.map { |row| transform_row(row) }
    end

    def transform_row(row)
      {
        unique_id: row[0],
        type: row[1],
        title: row[2],
        original_title: row[3],
        adult: row[4] == "1",
        start_year: row[5] == '\N' ? nil : row[5].to_i,
        end_year: row[6] == '\N' ? nil : row[6].to_i,
        runtime: row[7].to_i
      }
    end
  end
end
