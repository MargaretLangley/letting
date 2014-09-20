####
#
# A property, under management by the letting company.
#
# Properties have an account. They have tenants (see contact module),
# Agents responsible for account charges ( the agent). Money
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
  has_one :agent, dependent: :destroy, inverse_of: :property
  accepts_nested_attributes_for :agent, allow_destroy: true

  validates :human_ref, numericality: true
  validates :human_ref, uniqueness: true
  validates :entities, presence: true
  before_validation :clear_up_form

  delegate :abbreviated_address, to: :address

  def occupier
    entities.full_name
  end

  def prepare_for_form
    prepare_contact
    build_agent if agent.nil?
    agent.prepare_for_form
    build_account if account.nil?
    account.prepare_for_form
  end

  def clear_up_form
    entities.clear_up_form
    account.clear_up_form if account.present?
  end

  def bill_to_s
    agent.bill_to.to_address
  end

  def to_address
    occupier + "\n" + address.text
  end

  delegate :bill_to, to: :agent

  include Searchable
  # Elasticsearch uses generates JSON document for property index
  def as_indexed_json(_options = {})
    as_json(
      methods: :occupier,
      include: {
        address: {},
        agent: { methods: [:to_address], only: [:to_address] }
      })
  end
end
