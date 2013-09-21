class Account < ActiveRecord::Base
  belongs_to :property
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  def debt debt_args
    debts.build debt_args
  end

  def generated_debts debt_infos
    debt_infos.each {|debt_info| debts.build debt_info.to_hash }
  end

  def new_debts
    debts.select(&:new_record?)
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
