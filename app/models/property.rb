class Property < ActiveRecord::Base
  has_many :entities, dependent: :destroy, as: :entitieable
  accepts_nested_attributes_for :entities, allow_destroy: true, reject_if: :all_blank
  has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_one :billing_profile, dependent: :destroy
  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  validates :entities, :presence => true
  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true

  def prepare_for_form
    self.build_address if self.address.nil?
    (self.entities.count..1).each { self.entities.build }
    self.build_billing_profile.prepare_for_form if self.billing_profile.nil?
    true
  end

  def separate_billing_address
    billing_profile.use_profile
  end
  alias_method :separate_billing_address?, :separate_billing_address

  def separate_billing_address separate
    billing_profile.use_profile = separate
  end

  def bill_to
    billing_profile.use_profile? ? billing_profile : self
  end
end
