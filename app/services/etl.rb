# frozen_string_literal: true

class Etl
  def perform
    extract_data("name.basics.tsv.gz")
    load_person_data
  end

  private

  def transform_person_data(data)
    {
      unique_id: data[0],
      name: data[1],
      birth_year: data[2] == '\N' ? nil : data[2].to_i,
      death_year: data[3] == '\N' ? nil : data[3].to_i
    }
  end

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
    puts " #{filename} downloaded"
    filename
  end

  def load_person_data
    puts "Loading person data"
    person_data = []
    File.open("#{local_filename("name.basics.tsv.gz")}", mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        person_data << transform_person_data(line.split("\t"))
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
