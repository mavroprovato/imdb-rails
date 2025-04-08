namespace :imdb do
  desc "Load data from the IMDB dataset"
  task loaddata: :environment do
    puts "Loading person data..."
    response = Faraday.get("https://datasets.imdbws.com/name.basics.tsv.gz")
    Zlib::GzipReader.new(StringIO.new(response.body.to_s)).each_line.with_index do |line, index|
      next if index == 0

      data = line.split("\t")
      person = Person.new(unique_id: data[0], name: data[1])
      person.save
    end
    puts "Person data loaded."
  end
end
