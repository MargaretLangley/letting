####
#
# A property, under management by the letting company.
#
# Properties have an account. They have tenants (see contact module),
# Agents responsible for account charges ( the billing_profile). Money
# collected goes to the properties client.
#
# The code is part of the representation of a property.
#
####
#
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
    build_billing_profile if billing_profile.nil?
    billing_profile.prepare_for_form
    build_account if account.nil?
    account.prepare_for_form
  end

  def clear_up_after_form
    entities.clean_up_form
    account.clean_up_form if account.present?
  end

  def bill_to
    billing_profile.bill_to
  end

  def start_address
    [address.flat_no, address.house_name, address.road_no, address
    .road].reject(&:blank?).join('  ')
  end

  def self.properties property_ids
    Property.where(id: property_ids)
  end

  def self.search_by_house_name(search)
    Property.includes(:address)
    .where('addresses.house_name ILIKE ?', "#{search}")
    .references(:address)
  end

  def self.search search
    case
    when search.blank?
      Property.all.includes(:address).order(:human_id)
    when human_ids(search)
      search_by_human_id(search)
    else
      search_by_all(search)
    end
  end

  def self.search_min search
    case
    when search.blank?
      none
    when human_ids(search)
      search_by_human_id(search)
    else
      search_by_all(search)
    end
  end

  private

    def self.search_by_human_id(search)
      human_ids = search.split('-')
      human_ids[1] = human_ids[0] if human_ids[1].blank?
      Property.includes(:address, :entities)
                    .where(human_id: human_ids[0]..human_ids[1])
                    .references(:address, :entity).order(:human_id)
    end

    def self.search_by_all(search)
      Property.includes(:address, :entities)
        .where('human_id = :i OR ' +
               'entities.name ILIKE :s OR ' +
               'addresses.house_name ILIKE :s OR ' +
               'addresses.road ILIKE :s OR ' +
               'addresses.town ILIKE :s',
               i: "#{search.to_i}",
               s: "#{search}%" \
               ).references(:address, :entity).order(:human_id)
    end

    def self.human_ids search
      # matches a number (\d) followed by any amount of whitespace (\s)
      # optional hyphen (-) and optional number (\d)
      (search =~ /^(\d+\s*-?)+\s*\d+$/).present?
    end

end
