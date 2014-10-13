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

  def prepare(invoice_date: Date.current)
    self.invoice_date = invoice_date
    letters.build template: Template.find(1)
    self
  end

  def property(property_ref:, property_address:, billing_address:)
    self.property_ref = property_ref
    self.property_address = property_address
    self.billing_address = billing_address
  end

  def account(arrears:, total_arrears:, debits:)
    self.arrears = arrears
    self.total_arrears = total_arrears
    self.products = debits.map { |debit| Product.new debit.to_debitable }
  end

  def client(client:)
    self.client_address = client
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "Arrears: #{arrears.inspect}\n"\
    "client: #{client_address.inspect}\n"
  end
end
