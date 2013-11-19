####
#
# The Account is a summation of charges, debits, and credits on a property.
#
# The property is the
# a property should become due a charge.
#
# The account has one property. A property has a number of charges.
# The charges generate debits and credits are made to cover these debits.
#
####
#
class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  has_many :debits, dependent: :destroy
  has_many :credits, dependent: :destroy
  accepts_nested_attributes_for :credits, allow_destroy: true
  has_many :payments, dependent: :destroy
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true


  def prepare_debits date_range
    debits = []
    chargeables_between(date_range).each  do |chargeable|
      debits.push Debit.new chargeable.to_hash
    end
    debits
  end

  def prepare_credits
    credits = []
    credits.push prepare_credits_for_unpaid_debits
    credits.push prepare_advanced_credits
    # compact removes nil elements from the array
    credits.compact.reduce([], :|)
  end

  def prepare_for_form
    charges.prepare
  end

  def clear_up_form
    charges.clear_up_form
  end

  def self.by_human_ref human_ref
    Account.joins(:property).find_by(properties: { human_ref: human_ref })
  end

  private

    # call once per request
    #
    def prepare_credits_for_unpaid_debits
      credits = []
      unpaid_debits.each do |debit|
        credits.push Credit.new account_id: id,
                                debit: debit,
                                charge_id: debit.charge_id,
                                advance: false
      end
      credits
    end

    def prepare_advanced_credits(date_range = Date.current..Date.current + 1.years)
      credits = []
      charges.chargeables_between(date_range).each do |chargeable|
        credits.push Credit.new chargeable.to_hash on_date: Date.current,
                                                   advance: true,
                                                   amount: 0
      end
      credits
    end

    def chargeables_between date_range
      charges.chargeables_between(date_range)
        .reject { |chargeable| already_charged_for? chargeable }
    end

    def already_charged_for? chargeable
      debits.any? do |debit|
        debit.already_charged? Debit.new(chargeable.to_hash)
      end
    end

    def unpaid_debits
      debits.reject(&:paid?)
    end
end
