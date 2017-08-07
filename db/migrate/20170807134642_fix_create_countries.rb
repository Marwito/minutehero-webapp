class FixCreateCountries < ActiveRecord::Migration[5.0]
  def change
    Country.delete_all
    countries = [
      %w(AT Austria), %w(BE Belgium), %w(BG Bulgaria), %w(HR Croatia),
      %w(CY Cyprus), %w(CZ Czech Republic), %w(DK Denmark), %w(EE Estonia),
      %w(FI Finland), %w(FR France), %w(DE Germany), %w(GR Greece),
      %w(HU Hungary), %w(IS Iceland), %w(IE Ireland), %w(IT Italy),
      %w(LV Latvia), %w(FL Liechtenstein), %w(LI Lithuania), %w(LU Luxembourg),
      %w(MT Malta), %w(NL Netherlands), %w(NO Norway), %w(PL Poland),
      %w(PO Portugal), %w(RO Romania), %w(SK Slovakia), %w(SL Slovenia),
      %w(ES Spain), %w(SW Sweden), %w(CH Switzerland), %w(GB United\ Kingdom)
    ]
    countries.each do |code, country|
      Country.create(alpha2_code: code, name: country)
    end
  end
end
