# frozen_string_literal: true

module Loaders
  # Base class for loading data
  class BaseLoader
    def load_data(batch_size = 100_000)
      local_filename = Downloader.new(filename).download
      Rails.logger.info "Running #{self.class}"
      rows_processed = 0
      each_batch(Zlib::GzipReader.new(File.open(local_filename, mode: 'rb')), batch_size) do |batch|
        process_data(batch)
        rows_processed += batch.size
        Rails.logger.info "Processed #{rows_processed} rows"
      end
      Rails.logger.info "#{self.class} finished"
    end

    protected

    def filename
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
    end

    def process_data(batch)
      raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
    end

    private

    def each_batch(file_reader, batch_size)
      batch = []
      file_reader.each_line.with_index do |line, index|
        # Skip first line - header
        next if index.zero?

        batch << line.split("\t")
        if (index % batch_size).zero?
          yield batch
          batch = []
        end
      end
      yield batch
    end
  end
end
