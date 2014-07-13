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

  def full_name
    entities.full_name
  end

  def prepare_for_form
    prepare_contact
  end

  def clear_up_form
    entities.clear_up_form
  end

  include Searchable
  def as_indexed_json(_options={})
    as_json(
      methods: :full_name,
      include: {
        address: {}
      })
  end

  def self.sql_search search
    if search.blank?
      Client.all.includes(:address).order(:human_ref)
    else
      search(query).records
    end
  end
end
