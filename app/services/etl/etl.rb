# frozen_string_literal: true

module Etl
  # All loader classes used to load data
  LOADERS = [
    Loaders::TitleBasicsLoader,
    Loaders::TitleRatingsLoader,
    Loaders::TitleAliasLoader,
    Loaders::TitleEpisodeLoader,
    Loaders::NameBasicsLoader,
    Loaders::TitleCrewLoader,
    Loaders::TitlePrincipalsLoader
  ].freeze

  # Performs the ETL procedure
  class Etl
    # Performs the ETL procedure, by using all the available loaders.
    def perform
      LOADERS.each { |loader_class| loader_class.new.load_data }
    end
  end
end
