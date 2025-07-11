# frozen_string_literal: true

module Etl
  module Loaders
    # String that indicates a null value for a column
    NULL_VALUE = '\N'

    # Base class for loading data
    class BaseLoader
      # Load the data from the TSV file.
      #
      # The method downloads the filename returned by the {#filename} method and loads the data that should be imported
      # by the {#process_data} method.
      # @param batch_size [Integer] The number of rows to process in each batch. By default, 10000 rows are processed.
      def load_data(batch_size = 10_000)
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

      # Returns the name of the file that should be downloaded by the loader. This method must be implemented by
      # subclasses.
      #
      # @return [String] The filename.
      # @abstract
      def filename
        raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
      end

      # Processes the data loaded from the file and loads the data to the database. This method must be implemented by
      # subclasses
      #
      # @abstract
      def process_data(batch)
        raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
      end

      private

      # rubocop:disable Metrics/MethodLength
      def each_batch(file_reader, batch_size)
        headers = []
        batch = []
        file_reader.each_line.with_index do |line, index|
          if index.zero?
            headers = line.chomp.split("\t").map(&:to_sym)
          else
            batch << headers.zip(line.chomp.split("\t")).to_h
            if (index % batch_size).zero?
              yield batch
              batch = []
            end
          end
        end
        yield batch
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
