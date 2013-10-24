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
  has_many :payments
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true

  def chargeables_between date_range
    charges.chargeables_between(date_range)
      .reject { |chargeable| already_charged_for? chargeable }
  end

  def add_debit debit_args
    debits.build debit_args
  end

  def add_credit credit
    credits << credit
  end

  def unpaid_debits
    debits.reject(&:paid?)
  end

  def prepare_for_form
    charges.prepare
  end

  def clean_up_form
    charges.clean_up_form
  end

  def self.by_human_id human_id
    Account.joins(:property).find_by(properties: { human_id: human_id })
  end

  private

    def already_charged_for? chargeable
      debits.any? do |debit|
        debit.already_charged? Debit.new(chargeable.to_hash)
      end
    end

    def new_debits
      debits.select(&:new_record?)
    end
end
