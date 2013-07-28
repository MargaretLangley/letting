class Property < ActiveRecord::Base
  include Contact

  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true

end
