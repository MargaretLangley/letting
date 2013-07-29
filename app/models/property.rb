class Property < ActiveRecord::Base
  include Contact
  has_one :billing_profile, dependent: :destroy
  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true

  def separate_billing_address?
    billing_profile.present?
  end

  def bill_to
    billing_profile || self
  end

end
