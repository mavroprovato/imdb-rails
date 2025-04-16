# frozen_string_literal: true

module Loaders
  class BaseLoader
    protected

    def read_batch(data_filename, batch_size = 100_000)
      data = []
      File.open(data_filename, mode: "rb") do |file|
        Zlib::GzipReader.new(file).each_line.with_index do |line, index|
          next if index == 0

          data << line.split("\t")
          if index % batch_size == 0
            yield data
            data = []
            puts "Processed #{index} rows"
          end
        end
        yield data
        puts "Processed all rows"
      end
    end
  end
end
