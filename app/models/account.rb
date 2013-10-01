class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true

  def prepare_for_form
    charges.prepare
  end

  def clean_up_form
    charges.clean_up_form
  end

  def add_debt debt_args
    debts.build debt_args
  end

  def generate_debts_for date_range
    generate_debts_from_chargeable charges.charges_between date_range
    new_debts
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

  private

    def generate_debts_from_chargeable chargeable_infos
      chargeable_infos.each {|chargeable| debts.build chargeable.to_hash }
    end

    def new_debts
      debts.select(&:new_record?)
    end
end
