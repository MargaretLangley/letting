class Property < ActiveRecord::Base
  has_many :addresses, dependent: :destroy, as: :contact
  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true

  def location_address
    addresses.first
  end
end
