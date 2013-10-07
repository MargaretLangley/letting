####
#
# Address
#
# Why does the class exist?
#
# Represents an address of either a property or a person in the system.
#
# How does it fit in the larger system?
#
# Property, Billing Addresses (Agents) and Clients all require and has_one
# address.
#
####
#
class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, :road_no, length: { maximum: 10 }, allow_blank: true
  validates :house_name, length: { maximum: 64 }, allow_blank: true
  validates :road,       length: { maximum: 64 }
  validates :district, :town, length: { minimum: 4, maximum: 64 },
                              allow_blank: true
  validates :county,     length: { minimum: 4, maximum: 64 }
  validates :postcode,   length: { minimum: 6, maximum: 8 }, allow_blank: true

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  def copy_approved_attributes
    attributes.except(*ignored_attrs)
  end

  private

    def ignored_attrs
      %w[id addressable_id addressable_type created_at updated_at]
    end
end
