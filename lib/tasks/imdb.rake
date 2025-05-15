# frozen_string_literal: true

namespace :imdb do
  desc "Load data from the IMDB dataset"
  task load_data: :environment do
    Etl.new.perform
  end
end
