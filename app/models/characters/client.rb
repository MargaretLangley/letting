####
#
# Client
#
# Clients
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

  validates :human_ref, numericality: { only_integer: true, greater_than: 0 }
  validates :human_ref, uniqueness: true
  validates :entities, presence: true

  delegate :full_name, to: :entities

  def prepare_for_form
    prepare_contact
  end

  def to_s
    full_name + "\n" + address.text
  end

  delegate :clear_up_form, to: :entities

  include Searchable
  def as_indexed_json(_options = {})
    as_json(methods: :to_s)
  end
end
