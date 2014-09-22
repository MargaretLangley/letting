class Invoicing < ActiveRecord::Base
  has_many :invoices

  def generate(account_ids:)
    accounts = Account.find account_ids
    self.property_range = properties_range(accounts)
    accounts.each do |account|
      invoice = invoices.build
      invoice.prepare account: account
      invoice.prepare_products debits: account.prepare_debits(start_date..end_date)
    end
  end

  def properties_range accounts
    "#{accounts.first.property.human_ref} - #{accounts.last.property.human_ref}"
  end
end
