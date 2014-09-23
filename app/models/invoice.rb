# Invoice Requires
#
# Agent
# - Compound Name and address
# Property Ref
# Invoice Date
# Property Address
# Arrears
#  - balance on the account on that day
#
# Invoice item
#   - Charge Type
#   - Date Due
#   - Description
#   - Amount
#   - Balance
#   - Time Period the charge covers
#
# - Total Owing
#
# Client
#   - Compound Name and address
#
class Invoice < ActiveRecord::Base
  belongs_to :invoicing
  has_many :products
  validates :products,
            :invoice_date,
            :property_ref,
            :property_address,
            :arrears,
            presence: true

  def prepare(invoice_date: Date.current, account:)
    self.billing_address = account.property.bill_to_s
    self.property_ref = account.property.human_ref
    self.invoice_date = invoice_date

    self.property_address = account.property.to_address

    self.arrears = account.balance
    # items
    # self.total_arrears = < sum >
    self.client = account.property.client.to_s
    self
  end

  def prepare_products(debits:)
    self.products = debits.map do |debit|
      Product.new charge_type: debit.charge_type,
                  date_due: debit.on_date,
                  amount: debit.amount
      # TODO: range
    end
  end

  def to_s
    p "Billing Address: #{billing_address.inspect}",
      "Property Ref: #{property_ref.inspect}",
      "Invoice Date: #{invoice_date.inspect}",
      "Property Address: #{property_address.inspect}",
      "Arrears: #{arrears.inspect}",
      "client: #{client.inspect}"
  end
end
