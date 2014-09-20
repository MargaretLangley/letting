class Invoicing < ActiveRecord::Base
  has_many :invoices

  def generate(account_ids:)
    accounts = Account.find account_ids
    self.property_range = properties_range(accounts)
    accounts.each do |account|
      invoices.build.prepare account: account
    end
  end


  def properties_range accounts
    "#{accounts.first.property.human_ref} - #{accounts.last.property.human_ref}"
  end
end
