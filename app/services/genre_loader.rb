# frozen_string_literal: true

class GenreLoader
  def load_data
    genres = Set.new
    read_batch(Downloader.new(filename).download) do |batch|
      batch.each do |row|
        genres |= transform_row(row)
      end
    end
    Genre.import genres.to_a, validate: false
  end

  protected

  def read_batch(data_filename)
    data = []
    File.open(data_filename, mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        data << line.split("\t")
        if index % 100_000 == 0
          yield data
          data = []
          puts "Processed #{index} rows"
        end
      end
      yield data
      puts "Processed all rows"
    end
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
