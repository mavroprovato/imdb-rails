# frozen_string_literal: true

module Loaders
  class BaseLoader
    def load_data
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method "
    end

    protected

    def filename
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
    end

    def read_batch(data_filename, batch_size = 100_000)
      data = []
      Zlib::GzipReader.new(File.open(data_filename, mode: "rb")).each_line.with_index do |line, index|
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
