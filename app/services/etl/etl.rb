# frozen_string_literal: true

module Etl
  # All loader classes used to load data
  LOADERS = [
    Loaders::GenreLoader, Loaders::RegionLoader, Loaders::LanguageLoader, Loaders::TitleLoader, Loaders::PeopleLoader,
    Loaders::TitleAliasLoader
  ].freeze

  # Performs the ETL procedure
  class Etl
    def perform
      LOADERS.each { |loader_class| loader_class.new.load_data }
    end
  end
end
