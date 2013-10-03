class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true

  def chargeables_between date_range
    charges.chargeables_between(date_range)
      .reject { |chargeable| already_charged_for? chargeable }
  end

  def add_debt debt_args
    debts.build debt_args
  end

  def payment payment_args
    payments.build payment_args
  end

  def unpaid_debts
    debts.reject(&:paid?)
  end

  def self.lastest_payments number_of
    Payment.latest_payments number_of
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
