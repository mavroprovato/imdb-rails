namespace :imdb do
  desc "Load data from the IMDB dataset"
  task loaddata: :environment do
    puts "Downloading person data"
    response = Faraday.get("https://datasets.imdbws.com/name.basics.tsv.gz")
    filename = "#{Rails.root}/tmp/name.basics.tsv.gz"
    File.open(filename, mode: "wb") do |file|
      file.write(response.body)
    end
    puts "Person data downloaded"
    puts "Loading person data"
    person_data = []
    File.open(filename, mode: "rb") do |file|
      Zlib::GzipReader.new(file).each_line.with_index do |line, index|
        next if index == 0

        data = line.split("\t")
        person_data << {
          unique_id: data[0],
          name: data[1],
          birth_year: data[2] == '\N' ? nil : data[2].to_i,
          death_year: data[3] == '\N' ? nil : data[3].to_i
        }

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
