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
# rubocop: disable Lint/UnusedMethodArgument
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
  validates :agent, :entities, presence: true
  before_validation :clear_up_form

  delegate :text, to: :address, prefix: true
  delegate :abridged_text, to: :address

  def occupiers
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

  def invoice billing_period: nil
    {
      property_ref: human_ref,
      occupiers: occupiers,
      property_address: to_address,
      billing_address: bill_to_s,
      client_address: client.to_s,
    }
  end

  def to_billing
    address.name_and_address name: occupiers
  end

  delegate :bill_to, to: :agent

  include Searchable
  # Elasticsearch uses generates JSON document for property index
  def as_indexed_json(_options = {})
    as_json(
      methods: :occupiers,
      include: {
        address: {},
        agent: { methods: [:to_address], only: [:to_address] }
      })
  end

  private

  def to_address
    return unless address
    address.text
  end

  def bill_to_s
    agent.bill_to.to_billing
  end
end
