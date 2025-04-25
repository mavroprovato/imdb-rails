# frozen_string_literal: true

namespace :imdb do
  desc "Load data from the IMDB dataset"
  task loaddata: :environment do
    etl = Etl.new
    etl.perform
  end
end
