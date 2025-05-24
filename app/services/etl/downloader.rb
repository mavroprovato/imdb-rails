# frozen_string_literal: true

module Etl
  # Helper class which downloads dump files to be imported to the database
  class Downloader
    BASE_URL = 'https://datasets.imdbws.com'
    DOWNLOAD_DIR = Rails.root.join('/tmp')

    def initialize(filename)
      @filename = filename
    end

    def download
      return local_filename unless should_download?

      save_local_etag(download_file)
      local_filename
    end

    private

    attr_reader :filename

    def remote_etag
      Faraday.head("#{BASE_URL}/#{filename}").headers['etag']
    end

    def local_etag_filename
      "#{DOWNLOAD_DIR}/#{filename}.etag"
    end

    def local_etag
      File.read(local_etag_filename).chomp
    rescue Errno::ENOENT
      nil
    end

    def save_local_etag(etag)
      File.open(local_etag_filename, mode: 'wt') do |file|
        file.write(etag)
      end
    end

    def should_download?
      remote_etag != local_etag
    end

    def local_filename
      "#{DOWNLOAD_DIR}/#{filename}"
    end

    def download_file
      Rails.logger.info "Downloading #{filename}"
      response = Faraday.get("#{BASE_URL}/#{filename}")
      File.open(local_filename, mode: 'wb') do |file|
        file.write(response.body)
      end
      Rails.logger.info "#{filename} downloaded"
      response.headers['etag']
    end
  end
end
