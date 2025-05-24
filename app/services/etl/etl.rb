# frozen_string_literal: true

module Etl
  LOADERS = [Loaders::GenreLoader, Loaders::TitleLoader, Loaders::PeopleLoader].freeze
  # Performs the ETL procedure
  class Etl
    def perform
      LOADERS.each { |loader_class| loader_class.new.load_data }
    end
  end
end
