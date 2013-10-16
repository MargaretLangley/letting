####
#
# The Account is a summation of charges, debts, and credits on a property.
#
# The property is the
# a property should become due a charge.
#
# The account has one property. A property has a number of charges.
# The charges generate debts and credits are made to cover these debts.
#
####
#
class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  has_many :debts, dependent: :destroy
  has_many :credits, dependent: :destroy
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true

  def chargeables_between date_range
    charges.chargeables_between(date_range)
      .reject { |chargeable| already_charged_for? chargeable }
  end

  def add_debt debt_args
    debts.build debt_args
  end

  def add_credit credit_args
    credits.build credit_args
  end

  def unpaid_debts
    debts.reject(&:paid?)
  end

  def prepare_for_form
    charges.prepare
  end

  def clean_up_form
    charges.clean_up_form
  end

  private

    def already_charged_for? chargeable
      debts.any? { |debt| debt.already_charged? Debt.new(chargeable.to_hash) }
    end

    def new_debts
      debts.select(&:new_record?)
    end
end
