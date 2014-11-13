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
#
class Invoice < ActiveRecord::Base
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

  def prepare(invoice_date: Date.current, property:, billing:)
    self.invoice_date = invoice_date
    letters.build template: Template.find(1)
    property property
    self.invoice_account =  billing[:transaction]
    self.products = generate_products(billing)[:products]
    self.total_arrears = generate_products(billing)[:products].last.balance
    self
  end

  def generate_products(billing)
    @generate_products ||= ProductsMaker.new(invoice_date: invoice_date,
                                             **billing).invoice
  end

  def property(property_ref:, property_address:, billing_address:, client_address:) # rubocop: disable Metrics/LineLength
    self.property_ref = property_ref
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
end
