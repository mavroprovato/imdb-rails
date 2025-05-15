# frozen_string_literal: true

class Downloader
  BASE_URL = "https://datasets.imdbws.com"
  DOWNLOAD_DIR = Rails.root.join("/tmp")

  def initialize(filename)
    @filename = filename
  end

  def download
    return local_filename unless should_download?

    puts "Downloading #{filename}"
    response = Faraday.get("#{BASE_URL}/#{filename}")
    File.open(local_filename, mode: "wb") do |file|
      file.write(response.body)
    end
    File.open(local_etag_filename, mode: "wt") do |file|
      file.write(response.headers["etag"])
    end
    puts "#{filename} downloaded"
    local_filename
  end

  private

  attr_reader :filename

  def remote_etag
    Faraday.head("#{BASE_URL}/#{filename}").headers["etag"]
  end

  def local_etag
    begin
      File.read(local_etag_filename).chomp
    rescue Errno::ENOENT
      nil
    end
  end

  def should_download?
    remote_etag != local_etag
  end

  def local_filename
    "#{DOWNLOAD_DIR}/#{filename}"
  end

  def local_etag_filename
    "#{DOWNLOAD_DIR}/#{filename}.etag"
  end
end
