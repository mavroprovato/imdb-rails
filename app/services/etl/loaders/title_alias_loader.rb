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
        TitleAlias.import title_alias_data(batch), validate: false, on_duplicate_key_ignore: true
      end

      def title_alias_data(batch)
        batch.map { |row| transform_row(row) }
      end

      def titles
        @titles ||= Title.pluck(:id, :unique_id).each_with_object({}) { |(id, unique_id), hash| hash[unique_id] = id }
      end

      def regions
        @regions ||= Region.pluck(:id, :code).each_with_object({}) { |(id, code), hash| hash[code] = id }
      end

      def languages
        @languages ||= Language.pluck(:id, :code).each_with_object({}) { |(id, code), hash| hash[code] = id }
      end

      # rubocop:disable Metrics/AbcSize
      def transform_row(row)
        {
          title_id: titles[row[0]],
          ordering: row[1].to_i,
          name: row[2],
          region_id: row[3] == '\N' ? nil : regions[row[3]],
          language_id: row[4] == '\N' ? nil : languages[row[4]],
          alias_type: row[5] == '\N' ? nil : row[5],
          extra_attribute: row[6] == '\N' ? nil : row[6],
          original_title: row[7] == '1'
        }
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
