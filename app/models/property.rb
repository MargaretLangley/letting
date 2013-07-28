class Property < ActiveRecord::Base
  has_one :location_address, class_name: 'Address', dependent: :destroy, as: :addressable
  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true

  accepts_nested_attributes_for :location_address, allow_destroy: true
end
