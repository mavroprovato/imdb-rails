# frozen_string_literal: true

module Loaders
  class BaseLoader
    def load_data(batch_size = 100_000)
      local_filename = Downloader.new(filename).download
      batch = []
      Zlib::GzipReader.new(File.open(local_filename, mode: "rb")).each_line.with_index do |line, index|
        next if index == 0

        batch << line.split("\t")
        if index % batch_size == 0
          process_data(batch)
          batch = []
          Rails.logger.info "Processed #{index} rows"
        end
      end
      process_data(batch)
      Rails.logger.info "Processed all rows"
    end

    protected

    def filename
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
    end

    def process_data(batch)
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
    end
  end
end
