# frozen_string_literal: true

# A class that finds region names from the codes that are found in dumps
class RegionFinder
  # A hash that contains either non-standard codes, or codes for which we want to override their name.
  CODES = {
    'XWW' => 'Worldwide',
    'SUHH' => 'Soviet Union',
    'XEU' => 'Europe',
    'XYU' => 'Yugoslavia',
    'CSHH' => 'Czechoslovakia',
    'XWG' => 'West Germany',
    'XSA' => 'South America',
    'DDDE' => 'East Germany',
    'XKO' => 'Korea',
    'XSI' => 'Siam',
    'XAS' => 'Asia',
    'YUCS' => 'Federal Republic of Yugoslavia',
    'BUMM' => 'Burma',
    'XPI' => 'Palestine',
    'VDVN' => 'North Vietnam',
    'XAU' => 'Australasia',
    'ZRCD' => 'Zaire',
    'CSXX' => 'Serbia and Montenegro',
    'XKV' => 'Kosovo',
    'AN' => 'Netherlands Antilles',
    'XNA' => 'Netherlands Antilles'
  }.freeze

  # Return the region name.
  #
  # @param [String] The region code.
  # @return The region name.
  def self.region_name(code)
    return CODES[code] if CODES[code].present?

    ISO3166::Country.new(code).translation(:en)
  end
end
