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
# TODO: remove this disable!
# rubocop: disable Metrics/MethodLength
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

  def prepare(invoice_date: Date.current, account:, debits:)
    self.billing_address = account.property.bill_to_s
    self.property_ref = account.property.human_ref
    self.invoice_date = invoice_date

    self.property_address = account.property.to_address join: ', '
    self.arrears = account.balance
    # TODO: REMOVE FAKE TOTAL - Required to bypass database requirement
    debit_offset = 0
    debit_offset = debits.map(&:amount).inject(0, :+) if debits
    self.total_arrears = account.balance + debit_offset
    self.client = account.property.client.to_s
    letters.build template: Template.find(1)
    self
  end

  def prepare_products(debits:)
    self.products = debits.map { |debit| Product.new debit.to_debitable }
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
