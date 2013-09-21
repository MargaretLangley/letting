class Account < ActiveRecord::Base
  belongs_to :property
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  def debt debt_args
    debts.build debt_args
  end

  def debt_generated_within_date_range date_range
    debt_infos = property.charges.make_debt_between? date_range
    debt_infos.each {|debt_info| debts.build debt_info }
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

end
