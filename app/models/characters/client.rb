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

  delegate :full_name, to: :entities

  def prepare_for_form
    prepare_contact
  end

  delegate :clear_up_form, to: :entities

  include Searchable
  def as_indexed_json(_options = {})
    as_json(
      methods: :full_name,
      include: {
        address: {}
      })
  end
end
