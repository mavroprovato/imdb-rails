# frozen_string_literal: true

module Etl
  module Loaders
    # Processes the name.basics.tsv.gz file
    class NameBasicsLoader < BaseLoader
      def filename
        'name.basics.tsv.gz'
      end

      def process_data(batch)
        Profession.import profession_data(batch), validate: false, on_duplicate_key_ignore: true
        Person.import person_data(batch), validate: false, on_duplicate_key_update: {
          conflict_target: [:unique_id], columns: %i[name birth_year death_year]
        }
        PersonPrimaryProfession.import person_primary_profession_data(batch), validate: false,
                                                                              on_duplicate_key_ignore: true
        PersonKnownForTitle.import person_known_for_title_data(batch), validate: false,
                                                                       on_duplicate_key_ignore: true
      end

      private

      def profession_data(batch)
        batch.each_with_object(Set.new) do |row, set|
          next if row[4] == '\N'

          row[4].split(',').each { |name| set << { name: } }
        end.to_a
      end

      def person_data(batch)
        batch.map { |row| transform_person_row(row) }
      end

      def transform_person_row(row)
        {
          unique_id: row[0],
          name: row[1],
          birth_year: row[2] == '\N' ? nil : row[2].to_i,
          death_year: row[3] == '\N' ? nil : row[3].to_i
        }
      end

      def person_primary_profession_data(batch)
        profession_ids = professions
        person_ids = persons(batch)
        batch.each_with_object([]) do |row, array|
          next if row[4] == '\N'

          row[4].split(',').map do |name|
            array << { person_id: person_ids[row[0]], profession_id: profession_ids[name] }
          end
        end
      end

      def professions
        Profession.pluck(:id, :name).each_with_object({}) { |(id, name), hash| hash[name] = id }
      end

      def persons(batch)
        Person.where(
          unique_id: batch.map { |row| row[0] }
        ).pluck(:id, :unique_id).each_with_object({}) { |(id, unique_id), hash| hash[unique_id] = id }
      end

      def titles(batch)
        title_unique_ids = batch.each_with_object(Set.new) do |row, set|
          next if row[5] == '\N'

          row[5].split(',').each { |name| set << name }
        end
        Title.where(unique_id: title_unique_ids).pluck(:id, :unique_id).each_with_object({}) do |(id, unique_id), hash|
          hash[unique_id] = id
        end
      end

      def person_known_for_title_data(batch)
        person_ids = persons(batch)
        title_ids = titles(batch)
        batch.each_with_object([]) do |row, array|
          next if row[5] == '\N'

          row[5].split(',').each do |name|
            if title_ids[name].nil?
              Rails.logger.info "Title #{name} missing"
              next
            end
            array << { person_id: person_ids[row[0]], title_id: title_ids[name] }
          end
        end
      end
    end
  end
end
