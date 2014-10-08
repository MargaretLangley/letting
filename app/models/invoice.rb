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
  has_many :templates, through: :letters
  has_many :letters, dependent: :destroy

  def prepare(invoice_date: Date.current, account:)
    self.billing_address = account.property.bill_to_s
    self.property_ref = account.property.human_ref
    self.invoice_date = invoice_date

    self.property_address = account.property.to_address
    self.arrears = account.balance
    # TODO: REMOVE FAKE TOTAL - Required to bypass database requirement
    self.total_arrears = 11.00
    self.client = account.property.client.to_s
    letters.build template: Template.find(1)
    self
  end

  def prepare_products(debits:)
    self.products = debits.map do |debit|
      Product.new charge_type: debit.charge_type,
                  date_due: debit.on_date,
                  period: debit.period,
                  amount: debit.amount
    end
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "Arrears: #{arrears.inspect}\n"\
    "client: #{client.inspect}\n"
  end
end
