####
#
# Client
#
# Clients
#
# Clients have a number of properties. Clients have an address
# and contact information (address and entity).
#
# rubocop: disable Lint/UnusedMethodArgument
####
#
class Client < ActiveRecord::Base
  include Contact
  has_many :properties, dependent: :destroy
  before_validation :clear_up_form

  validates :human_ref, numericality: { only_integer: true, greater_than: 0 }
  validates :human_ref, uniqueness: true
  validates :entities, presence: true

  delegate :full_name, to: :entities

  def prepare_for_form
    prepare_contact
  end

  delegate :clear_up_form, to: :entities

  def to_s
    address.name_and_address name: full_name
  end

  include Searchable
  def as_indexed_json(_options = {})
    as_json(methods: :to_s)
  end
end
