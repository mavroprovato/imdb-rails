# frozen_string_literal: true

class GenreLoader < Loader

  def load_data
    puts "Loading genre data..."
    genres = Set.new
    read_batch(Downloader.new(filename).download) do |batch|
      batch.each do |row|
        genres |= transform_row(row)
      end
    end
    Genre.import genres.to_a, validate: false
    puts "Genre data loaded"
  end

  private

  def filename
    "title.basics.tsv.gz"
  end

  def transform_row(row)
    return {} if row[8].chomp == '\N'

    row[8].chomp.split(",").map { |name| { name: } }
  end
end
