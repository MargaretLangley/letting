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
  belongs_to :run, inverse_of: :invoices
  belongs_to :debits_transaction, autosave: true, inverse_of: :invoices
  has_many :comments, dependent: :destroy
  has_many :products, -> { order(:created_at) }, dependent: :destroy do
    def earliest_date_due
      map(&:date_due).min
    end

    def total_arrears
      last.balance
    end
  end
  validates :products,
            :invoice_date,
            :property_ref,
            :property_address,
            presence: true
  has_many :templates, through: :letters
  has_many :letters, dependent: :destroy

  after_destroy :destroy_orphaned_debits_transaction

  delegate :earliest_date_due, to: :products
  delegate :total_arrears, to: :products

  # prepare
  # Assigns the attributes required in an invoice
  # Args:
  # account            - account invoice is being prepared for
  # invoice_date       - the date which this invoice is being said to have been
  #                      sent.
  # property           - property that the invoice is being prepared for
  # debits_transaction - a transaction made up of the debits that will be added
  #                      to the invoice
  # comments           - array of strings to appear on invoice for special info.
  #
  def prepare account:,
              invoice_date: Time.zone.today,
              property:,
              debits_transaction:,
              comments: []
    self.account = account
    self.invoice_date = invoice_date
    letters.build template: Template.find(1)
    self.property = property
    self.comments = generate_comments comments: comments
    self.debits_transaction = debits_transaction

    self.products =
      products_maker arrears: account.balance(to_date: invoice_date),
                     transaction: debits_transaction
    self
  end

  # remake
  # Re-generates the invoice as if it happened on another date
  # The new invoice will take into account invoice_date and changes in account
  # balance
  #
  def remake invoice: Invoice.new, comments: []
    invoice.prepare account: account,
                    invoice_date: Time.zone.today,
                    property: property,
                    debits_transaction: debits_transaction,
                    comments: comments
  end

  def back_page?
    products.any?(&:back_page?)
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "client: #{client_address.inspect}\n"
  end

  private

  def property=(property_ref:, occupiers:, property_address:, billing_address:, client_address:) # rubocop: disable Metrics/LineLength
    self.property_ref = property_ref
    self.occupiers = occupiers
    self.property_address = property_address
    self.billing_address = billing_address
    self.client_address = client_address
  end

  def destroy_orphaned_debits_transaction
    debits_transaction.invoices.empty? && debits_transaction.destroy
  end

  def property
    {
      property_ref: property_ref,
      occupiers: occupiers,
      property_address: property_address,
      billing_address: billing_address,
      client_address: client_address,
    }
  end

  def generate_comments(comments:)
    comments.reject(&:blank?).map { |comment| Comment.new clarify: comment }
  end

  def products_maker(arrears:, transaction:)
    @products_maker ||= ProductsMaker.new(invoice_date: invoice_date,
                                          arrears: arrears,
                                          transaction: transaction).invoice
  end
end
