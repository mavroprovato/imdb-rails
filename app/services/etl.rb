# frozen_string_literal: true

class Etl
  def perform
    load_title_basics
  end

  private

  def local_filename(filename)
    "#{Rails.root}/tmp/#{filename}"
  end

  def extract_data(filename)
    puts "Downloading #{filename}"
    response = Faraday.get("https://datasets.imdbws.com/#{filename}")
    filename = local_filename(filename)
    File.open(filename, mode: "wb") do |file|
      file.write(response.body)
    end
    puts "#{filename} downloaded"
  end

  def read_data(filename)
    data = []
    File.open("#{local_filename(filename)}", mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        data << line.split("\t")
        if index % 10_000 == 0
          yield data
          data = []
        end
      end
      yield data
    end
  end

  def transform_title_data(data)
    {
      unique_id: data[0],
      type: data[1],
      title: data[2],
      original_title: data[3],
      adult: data[4] == "1",
      start_year: data[5] == '\N' ? nil : data[5].to_i,
      end_year: data[6] == '\N' ? nil : data[6].to_i,
      runtime: data[7].to_i
    }
  end

  def load_title_basics
    extract_data("title.basics.tsv.gz")
    read_data("title.basics.tsv.gz") do |data|
      title_data = data.map { |row| transform_title_data(row) }
      Title.import title_data, validate: false
    end
  end

  def transform_person_data(data)
    {
      unique_id: data[0],
      name: data[1],
      birth_year: data[2] == '\N' ? nil : data[2].to_i,
      death_year: data[3] == '\N' ? nil : data[3].to_i
    }
  end
end
