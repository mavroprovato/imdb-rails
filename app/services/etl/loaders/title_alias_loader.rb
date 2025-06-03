# frozen_string_literal: true

module Etl
  module Loaders
    # Loads title aliases to the database
    class TitleAliasLoader < BaseLoader
      protected

      def filename
        'title.akas.tsv.gz'
      end

      def process_data(batch)
        process_regions(batch)
        process_languages(batch)
        process_title_alias(batch)
      end

      private

      attr_reader :loaded_regions, :loaded_languages

      def read_regions(batch)
        batch.each_with_object(Set.new) do |row, set|
          next if row[:region] == NULL_VALUE

          set << row[:region]
        end
      end

      def region_data(batch)
        read_regions(batch).each_with_object([]) { |code, array| array << { code: } }
      end

      def load_regions(batch)
        Region.where(code: read_regions(batch)).pluck(:id, :code).each_with_object({}) do |(id, code), hash|
          hash[code] = id
        end
      end

      def process_regions(batch)
        Region.import region_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_regions = load_regions(batch)
      end

      def read_languages(batch)
        batch.each_with_object(Set.new) do |row, set|
          next if row[:language] == NULL_VALUE

          set << row[:language]
        end
      end

      def language_data(batch)
        read_languages(batch).each_with_object([]) { |code, array| array << { code: } }
      end

      def load_languages(batch)
        Language.where(code: read_languages(batch)).pluck(:id, :code).each_with_object({}) do |(id, code), hash|
          hash[code] = id
        end
      end

      def process_languages(batch)
        Language.import language_data(batch), validate: false, on_duplicate_key_ignore: true
        @loaded_languages = load_languages(batch)
      end

      def unique_titles(batch)
        batch.each_with_object(Set.new) { |row, set| row[:titleId].split(',').each { |name| set << name } }
      end

      def load_titles(batch)
        Title.where(unique_id: unique_titles(batch)).pluck(:id, :unique_id)
             .each_with_object({}) do |(id, unique_id), hash|
          hash[unique_id] = id
        end
      end

      def process_title_alias(batch)
        TitleAlias.import title_alias_data(batch), validate: false, on_duplicate_key_ignore: true
      end

      def title_alias_data(batch)
        title_ids = load_titles(batch)
        batch.map do |row|
          {
            title_id: title_ids[row[:titleId]],
            ordering: row[:ordering].to_i,
            name: row[:title],
            region_id: row[:region] == NULL_VALUE ? nil : loaded_regions[row[:region]],
            language_id: row[:language] == NULL_VALUE ? nil : loaded_languages[row[:language]],
            alias_type: row[:types] == NULL_VALUE ? nil : row[:types],
            extra_attribute: row[:attributes] == NULL_VALUE ? nil : row[:attributes],
            original_title: row[:isOriginalTitle] == '1'
          }
        end
      end
    end
  end
end
