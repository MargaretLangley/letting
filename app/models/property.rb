class Property < ActiveRecord::Base
  has_many :entities, dependent: :destroy, as: :entitieable
  accepts_nested_attributes_for :entities, allow_destroy: true, reject_if: :all_blank
  has_one :address, class_name: 'Address', dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_one :billing_profile, dependent: :destroy
  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  MAX_ENTITIES = 2

  validates :entities, :presence => true
  validates :human_property_reference, numericality: true
  validates :human_property_reference, uniqueness: true
  before_validation :clear_up_after_form

  def prepare_for_form
    self.build_address if self.address.nil?
    (self.entities.size...MAX_ENTITIES).each { self.entities.build }
    self.build_billing_profile if self.billing_profile.nil?
    billing_profile.prepare_for_form
    true
  end

  def clear_up_after_form
    self.entities.select(&:empty?).each {|entity| mark_entity_for_destruction entity }
    billing_profile.clear_up_after_form unless self.billing_profile.nil?
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

  private
    def mark_entity_for_destruction entity
      entity.mark_for_destruction
    end

end
