# frozen_string_literal: true

namespace :imdb do
  desc 'Load data from the IMDB dataset'
  task load_data: :environment do
    Rails.logger = Logger.new($stdout)
    Rails.logger.level = Logger::INFO
    Etl::Etl.new.perform
  end
end
