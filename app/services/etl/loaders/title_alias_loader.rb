# frozen_string_literal: true

module Etl
  module Loaders
    # Loads title aliases to the database
    class TitleAliasLoader < BaseLoader
      include LoadHelper

      protected

      # Returns the name of the file that should be downloaded by the loader. For this loader the filename is
      # title.akas.tsv.gz.
      #
      # @return String Returns title.akas.tsv.gz.
      def filename
        'title.akas.tsv.gz'
      end

      # Process the data loaded from the title.akas.tsv.gz file, and loads them to the database. This class loads
      # values for the {#Region}, {#Language} and {#TitleAlias} models.
      #
      # @param batch Array[Hash] The data to load.
      def process_data(batch)
        load_regions(batch)
        load_languages(batch)
        load_title_alias(batch)
      end

      private

      attr_reader :loaded_regions, :loaded_languages, :loaded_titles


      # Transform the region data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The transformed region data.
      def transform_regions(batch)
        read_unique_values(batch, :region).each_with_object([]) do |code, array|
          array << { code:, name: RegionFinder.region_name(code) }
        end
      end

      # Load the +Region+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_regions(batch)
        Region.import transform_regions(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_regions = loaded_values(Region, :code, read_unique_values(batch, :region))
      end

      # Transform the language data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The transformed language data.
      def language_data(batch)
        read_unique_values(batch, :language).each_with_object([]) do |code, array|
          array << { code:, name: LanguageFinder.language_name(code) }
        end
      end

      # Load the +Language+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_languages(batch)
        Language.import language_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_languages = loaded_values(Language, :code, read_unique_values(batch, :language))
      end

      # Transform each input row from the data file in order to be loaded into a +TitleAlias+ model.
      #
      # @param row Hash The data file input row.
      # @return Hash The transformed data.
      # rubocop:disable Metrics/AbcSize
      def transform_title_alias_row(row)
        {
          title_id: loaded_titles[row[:titleId]],
          ordering: transform_integer(row[:ordering]),
          name: row[:title],
          region_id: loaded_regions[row[:region]],
          language_id: loaded_languages[row[:language]],
          alias_types: transform_nilable_string_array(row[:types]),
          extra_attribute: transform_nilable_string(row[:attributes]),
          original_title: transform_boolean(row[:isOriginalTitle])
        }
      end
      # rubocop:enable Metrics/AbcSize

      # Transform the title alias data for each batch.
      #
      # @param batch Array[Hash] The batch data.
      # @return Array[Hash] The data to load.
      def title_alias_data(batch)
        batch.each_with_object([]) do |row, array|
          if loaded_titles[row[:titleId]].nil?
            Rails.logger.warn "Title #{row[:titleId]} not loaded"
            next
          end
          array << transform_title_alias_row(row)
        end
      end

      # Load the +TitleAlias+ data to the database.
      #
      # @param batch Array[Hash] The batch data.
      def load_title_alias(batch)
        @loaded_titles = loaded_values(Title, :unique_id, read_unique_values(batch, :titleId))
        TitleAlias.import title_alias_data(batch), validate: false, on_duplicate_key_ignore: true
      end
    end
  end
end
