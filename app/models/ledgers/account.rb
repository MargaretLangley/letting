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
  belongs_to :property, inverse_of: :account
  def holder
    property.occupier
  end

  def address
    property.address.text
  end
  has_many :debits, dependent: :destroy
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
  MAX_CHARGES = 4
  accepts_nested_attributes_for :charges, allow_destroy: true

  # For each charge it finds the next time it can be charged, if any,
  # and creates a debit.
  # date_range - dates which we prepare debits over
  #
  def make_debits date_range
    charges.map do |charge|
      charge.next_chargeable(date_range).map do |chargeable|
        Debit.new(chargeable.to_hash)
      end
    end.flatten
  end

  def make_credits
    charges.map { |charge| create_credit charge }
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
