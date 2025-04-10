# frozen_string_literal: true

class Etl
  def perform
    extract_data
    load_data
  end

  private

  def transform_person_data(line)
    data = line.split("\t")

    {
      unique_id: data[0],
      name: data[1],
      birth_year: data[2] == '\N' ? nil : data[2].to_i,
      death_year: data[3] == '\N' ? nil : data[3].to_i
    }
  end

  def extract_data
    puts "Downloading person data"
    response = Faraday.get("https://datasets.imdbws.com/name.basics.tsv.gz")
    filename = "#{Rails.root}/tmp/name.basics.tsv.gz"
    File.open(filename, mode: "wb") do |file|
      file.write(response.body)
    end
    puts "Person data downloaded"
    filename
  end

  def load_data
    puts "Loading person data"
    person_data = []
    File.open("#{Rails.root}/tmp/name.basics.tsv.gz", mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        person_data << transform_person_data(line)
        if index % 10_000 == 0
          Person.import person_data, validate: false
          person_data = []
        end
      end
    end
    Person.import person_data
    puts "Person data loaded."
  end
end
