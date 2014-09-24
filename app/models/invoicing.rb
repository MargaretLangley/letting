####
#
# Invoicing
#
# Creating a batch of invoices to bill customers.
#
# The user searches for property-ids within a date range that will be billed.
# Invoicing controller returns accounts that are to be debited to the invoicing
# object - which then creates the appropriate invoices for these properties.
#
# An invoice is the information required to print an invoice. Made up of
# property related information and the products (services) that are charged
# during the time period of the invoice.
#
class Invoicing < ActiveRecord::Base
  has_many :invoices
  validates :property_range, :start_date, :end_date, :invoices, presence: true

  def generate(account_ids:)
    accounts = invoicable_accounts account_ids: account_ids
    self.property_range = make_properties_range accounts
    make_invoices accounts: accounts
  end

  def invoicable_accounts(account_ids:)
    Account.find(account_ids)
           .select { |account| account.make_debits?(start_date..end_date) }
  end

  def make_properties_range accounts
    "#{accounts.first.property.human_ref} - #{accounts.last.property.human_ref}"
  end

  def make_invoices(accounts:)
    accounts.each do |account|
      make_invoice account: account,
                   debits: account.make_debits(start_date..end_date)
    end
  end

  def make_invoice(invoice: invoices.build, account:, debits:)
    invoice.prepare account: account
    invoice.prepare_products debits: debits
  end
end
