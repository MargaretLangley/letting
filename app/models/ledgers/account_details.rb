#
# AccountDetails
#
# SQL View onto Database - the table is a union of credits and debits.
#
#
class AccountDetails < ActiveRecord::Base
  belongs_to :account
  belongs_to :property
  def self.balance_all greater_than: 0
    AccountDetails.select('account_id, property_id, sum(amount) as amount')
      .group(:account_id, :property_id, :human_ref)
      .having('Sum(amount) >= ?', greater_than)
      .order(:human_ref)
  end
end
