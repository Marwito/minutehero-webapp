class Country < ApplicationRecord
  validates :name, :alpha2_code, presence: true

  DEFAULT_ALPHA_CODE = 'DE'
  class << self
    def alpha2_codes
      order(:name).pluck :alpha2_code
    end
  end
end
