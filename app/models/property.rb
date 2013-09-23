class Property < ActiveRecord::Base
  belongs_to :client
  has_one :account, dependent: :destroy, inverse_of: :property
  accepts_nested_attributes_for :account, allow_destroy: true
  include Contact
  has_one :billing_profile, dependent: :destroy, inverse_of: :property
  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  validates :human_id, :client_id, numericality: true
  validates :human_id, uniqueness: true
  validates :entities, presence: true
  before_validation :clear_up_after_form

  def prepare_for_form
    prepare_contact
    self.build_billing_profile if self.billing_profile.nil?
    billing_profile.prepare_for_form
    self.build_account if self.account.nil?
    account.prepare_for_form
  end

  def clear_up_after_form
    entities.clean_up_form
    self.account.clean_up_form if self.account.present?
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

  def self.properties property_ids
    Property.where(id: property_ids)
  end

  def self.search_by_house_name(search)
    Property.includes(:address).where('addresses.house_name LIKE ?',"#{search}").references(:address)
  end

  def self.search search
    if search.blank?
       Property.all.includes(:address).order(:human_id)
    else
      self.search_by_all(search)
    end
  end

  private
    def self.search_by_all(search)
      Property.includes(:address,:entities).
        where('human_id = :i OR ' + \
              'entities.name ILIKE :s OR ' + \
              'addresses.house_name ILIKE :s OR ' + \
              'addresses.road ILIKE :s OR '  \
              'addresses.town ILIKE :s',\
              i: "#{search.to_i}", s: "#{search}%" \
              ).references(:address, :entity).order(:human_id)
    end

end
