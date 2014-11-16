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
# TODO: remove methodlength error
# rubocop: disable Metrics/MethodLength
#
class Invoice < ActiveRecord::Base
  belongs_to :account
  belongs_to :run
  belongs_to :invoice_account, autosave: true, inverse_of: :invoices
  has_many :products, -> { order(:created_at) }, dependent: :destroy
  validates :products,
            :invoice_date,
            :property_ref,
            :property_address,
            presence: true
  has_many :templates, through: :letters
  has_many :letters, dependent: :destroy

  def prepare(account:, invoice_date: Date.current, property:, billing:)
    self.account = account
    self.invoice_date = invoice_date
    letters.build template: Template.find(1)
    self.property = property
    self.invoice_account =  billing[:transaction]

    products = generate_products(arrears: account.balance(to_date: invoice_date), # rubocop: disable Metrics/LineLength
                                 transaction: invoice_account)
    self.products = products[:products]
    self.total_arrears = products [:total_arrears]
    self.earliest_date_due = products [:earliest_date_due]
    self
  end

  def remake invoice: Invoice.new
    invoice.account = account
    invoice.invoice_date = Date.current
    invoice.letters.build template: Template.find(1)
    invoice.property = property
    invoice.invoice_account = invoice_account

    products = generate_products(arrears: account.balance(to_date: invoice_date), # rubocop: disable Metrics/LineLength
                                 transaction: invoice_account)
    invoice.products = products[:products]
    invoice.total_arrears = products [:total_arrears]
    invoice.earliest_date_due = products [:earliest_date_due]
    invoice
  end

  def property=(property_ref:, occupiers:, property_address:, billing_address:, client_address:) # rubocop: disable Metrics/LineLength
    self.property_ref = property_ref
    self.occupiers = occupiers
    self.property_address = property_address
    self.billing_address = billing_address
    self.client_address = client_address
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "client: #{client_address.inspect}\n"
  end

  private

  def property
    {
      property_ref: property_ref,
      occupiers: occupiers,
      property_address: property_address,
      billing_address: billing_address,
      client_address: client_address,
    }
  end

  def generate_products(arrears:, transaction:)
    @generate_products ||= ProductsMaker.new(invoice_date: invoice_date,
                                             arrears: arrears,
                                             transaction: transaction).invoice
  end
end
