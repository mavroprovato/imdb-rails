# frozen_string_literal: true

class Etl
  def perform
    load_title_basics
  end

  private

  def read_data(filename)
    data = []
    File.open(filename, mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        data << line.split("\t")
        if index % 10_000 == 0
          yield data
          data = []
          puts "Processed #{index} rows"
        end
      end
      yield data
      puts "Processed #{index} rows"
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
    read_data(Downloader.new("title.basics.tsv.gz").download) do |data|
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
