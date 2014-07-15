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

  validates :human_ref, :client_id, numericality: true
  validates :human_ref, uniqueness: true
  validates :entities, presence: true
  before_validation :clear_up_form

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

  delegate :bill_to, to: :agent

  def self.properties property_ids
    Property.where(id: property_ids)
  end

  include Searchable
  def as_indexed_json(_options = {})
    as_json(
      methods: :occupier,
      include: {
        address: {},
        agent: { methods: [:address_lines, :full_name], only: [:address_lines, :full_name] }
      })
  end

  def self.sql_search query
    case
    when query.blank?
      Property.all.includes(:address).order(:human_ref)
    when human_refs(query)
      sql_search_by_human_ref(query)
    else
      search(query).records
    end
  end

  def self.accounts_from_human_refs query
    sql_search_by_human_ref(query).map(&:account)
  end

  private

  def self.sql_search_by_human_ref(query)
    human_refs = query.split('-')
    human_refs[1] = human_refs[0] if human_refs[1].blank?
    Property.includes(:address, :entities)
                  .where(human_ref: human_refs[0]..human_refs[1])
                  .references(:address, :entity).order(:human_ref)
  end

  def self.human_refs query
    # matches a number (\d) followed by any amount of whitespace (\s)
    # optional hyphen (-) and optional number (\d)
    (query =~ /^(\d+\s*-?)+\s*\d+$/).present?
  end
end
