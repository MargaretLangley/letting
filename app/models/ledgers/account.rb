####
#
# The Account is a summation of charges, debits, and credits on a property.
#
# The account has one property. A property has a number of charges.
# The charges generate debits and payments create credits that cover
# these debits.
#
# Balance
# Debits increase an accounts balance +.
# Credits decrease an accounts balance -.
#
# Definition
#
# Accounts
# Receivable - money owed by customer for a service that has been delivered
#              but not paid for.
# Associations
# Provides queries for account records - required by Payment and debits.
#
####
#
class Account < ActiveRecord::Base
  include ChargesDefaults
  belongs_to :property, inverse_of: :account
  def holder
    property.occupiers
  end

  def address
    property.address.text
  end
  has_many :invoices
  has_many :debits, dependent: :destroy, inverse_of: :account do
    def exclusive? query_debit
      self.any? do |debit|
        debit.charge_id == query_debit.charge_id &&
        debit.on_date == query_debit.on_date
      end
    end
  end

  accepts_nested_attributes_for :debits, allow_destroy: true
  has_many :credits, dependent: :destroy
  accepts_nested_attributes_for :credits, allow_destroy: true
  has_many :payments, dependent: :destroy, inverse_of: :account
  has_many :charges, dependent: :destroy do
    def prepare
      (size...MAX_CHARGES).each { build }
      each(&:prepare)
    end

    def clear_up_form
      each(&:clear_up_form)
    end
  end
  accepts_nested_attributes_for :charges, allow_destroy: true

  # accounting_period - the date range that we generate debits for.
  # returns        - debits array with data required to bill the
  #                  associated account.
  def debits_coming accounting_period
    debits = []
    charges.each do |charge|
      charge.coming(accounting_period).map do |chargeable|
        debits << Debit.new(chargeable.to_hash)
      end
    end
    debits
  end

  def make_credits
    charges.map { |charge| create_credit charge }
  end

  def exclusive(query_debits:)
    query_debits.reject { |query_debit| debits.exclusive? query_debit }
  end

  def prepare_for_form
    charges.prepare
  end

  delegate :clear_up_form, to: :charges

  def balance to_date: Date.current
    (credits + debits).select { |transaction| transaction.on_date <= to_date }
                      .map(&:amount).inject(0, :+)
  end

  # Finds and returns a matching Account
  # human_ref - a account reference number, '2002'
  #
  def self.find_by_human_ref human_ref
    Account.between?(human_ref).first
  end

  # Searches for matching accounts between a range
  # query - an account or account range, '2002 - 3000'
  #
  def self.between? human_ref_range
    return Account.none if human_ref_range.nil?
    human_refs = human_ref_range.split('-')
    human_refs << human_refs.first if human_refs.size == 1
    Account.includes(:property)
           .where(properties: { human_ref: human_refs[0]..human_refs[1] })
           .order('properties.human_ref')
  end

  private

  def create_credit charge
    credits.build charge: charge, on_date: Date.current, amount: -charge.amount
  end
end
