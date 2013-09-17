class Account < ActiveRecord::Base
  belongs_to :property
  has_many :account_entries, dependent: :destroy

  def debt debt
    account_entries.build.debt debt
  end

  def payment payment
    account_entries.build.payment payment
  end

  def self.lastest_payments number_of
    AccountEntry.latest_payments number_of
  end




end
