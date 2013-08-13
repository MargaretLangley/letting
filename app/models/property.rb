class Property < ActiveRecord::Base
  belongs_to :client
  include Contact
  has_one :billing_profile, dependent: :destroy
  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  validates :human_id, numericality: true
  validates :human_id, uniqueness: true
  validates :entities, :presence => true
  before_validation :clear_up_after_form

  def prepare_for_form
    prepare_contact
    self.build_billing_profile if self.billing_profile.nil?
    billing_profile.prepare_for_form self
  end

  def clear_up_after_form
    entities_for_destruction :empty?
  end

  def separate_billing_address
    billing_profile.use_profile
  end
  alias_method :separate_billing_address?, :separate_billing_address

  def separate_billing_address separate
    billing_profile.use_profile = separate
  end

  def bill_to
    billing_profile.bill_to
  end

  def self.search_by_house_name(search)
    Property.includes(:address).where('addresses.house_name LIKE ?', "#{search}").references(:address)
  end

  def self.search_by_all(search)
    Property.includes(:address).
      where('addresses.house_name ILIKE ? OR ' + \
            'addresses.road ILIKE ? OR '  \
            'addresses.town ILIKE ?',  \
            "#{search}%", "#{search}%","#{search}%" \
            ).references(:address)
  end

end
