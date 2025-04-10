namespace :imdb do
  desc "Load data from the IMDB dataset"
  task loaddata: :environment do
    etl = Etl.new
    etl.load
  end
end
