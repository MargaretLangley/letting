class Sheet < ActiveRecord::Base

  MAX_STRING = 64
  MIN_POSTCODE = 6
  MAX_POSTCODE = 20

  validates :adams_name, :street, :district, :county, :postcode, presence: true
  validates :adams_name, :street, :district, :county,   length: {  maximum: MAX_STRING }
  validates :postcode,
            length: { minimum: MIN_POSTCODE, maximum: MAX_POSTCODE },
            allow_blank: true
end
