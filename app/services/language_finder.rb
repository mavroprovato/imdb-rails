# frozen_string_literal: true

# A class that finds language names from the codes that are found in dumps
class LanguageFinder
  # A hash that contains either non-standard codes, or codes for which we want to override their name.
  CODES = {
    'cmn' => 'Mandarin',
    'qbn' => 'Flemish',
    'qbp' => 'Castilian',
    'yue' => 'Cantonese',
    'el' => 'Greek',
    'qbo' => 'Serbo-Croatian',
    'qal' => 'Creole',
    'prs' => 'Dari',
    'jsl' => 'Japanese Sign Language',
    'fro' => 'French, Old',
    'qac' => 'Aboriginal'
  }.freeze

  # Return the language name.
  #
  # @param [String] The language code.
  # @return The language name.
  def self.language_name(code)
    return CODES[code] if CODES[code].present?

    ISO_639.find(code).english_name.split(';').first
  end
end
