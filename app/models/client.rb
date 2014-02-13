####
#
# A client is paid by the letting agency for collected payments
#
# Clients have a number of properties. Clients have an address
# and contact information (address and entity).
#
####
#
class Client < ActiveRecord::Base
  has_many :properties, dependent: :destroy
  include Contact
  before_validation :clear_up_form

  validates :human_ref, numericality: true
  validates :human_ref, uniqueness: true
  validates :entities, presence: true

  def prepare_for_form
    prepare_contact
  end

  def clear_up_form
    entities.clear_up_form
  end

  def self.sql_search search
    if search.blank?
      Client.all.includes(:address).order(:human_ref)
    else
      search_by_all(search)
    end
  end

  private

  def self.search_by_all(search)
    Client.includes(:address, :entities)
      .where('human_ref = :i OR ' +
             'entities.name ilike :s OR ' +
             'addresses.house_name ilike :s OR ' +
             'addresses.road ilike :s OR ' +
             'addresses.town ilike :s',
             i: "#{search.to_i}",
             s: "#{search}%")
      .references(:address, :entity).order(:human_ref)
  end
end
