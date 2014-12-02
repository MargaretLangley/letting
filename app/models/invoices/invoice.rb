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
# TODO: remove methodlength and ParameterLists errors
# rubocop: disable Metrics/MethodLength, Metrics/ParameterLists
#
class Invoice < ActiveRecord::Base
  belongs_to :account
  belongs_to :run, inverse_of: :invoices
  belongs_to :debits_transaction, autosave: true, inverse_of: :invoices
  has_many :comments, dependent: :destroy
  has_many :products, -> { order(:created_at) }, dependent: :destroy, inverse_of: :invoice do # rubocop: disable Metrics/LineLength
    def earliest_date_due
      map(&:date_due).min
    end

    def balanced
      total = 0 # if product != 0 then the first product is the balance.
      each_with_index do |product, _index|
        product.balance = total += product.amount
        product
      end
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

  def total_arrears
    products.balanced
    products.total_arrears
  end

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
  def prepare(account:,
              invoice_date: Time.zone.today,
              property:,
              debits_transaction:,
              comments: [],
              products:)
    self.account = account
    self.invoice_date = invoice_date
    letters.build template: Template.find(1)
    self.property = property
    self.comments = generate_comments comments: comments
    self.debits_transaction = debits_transaction

    self.products = products
    self
  end

  def back_page?
    products.any?(&:back_page?)
  end

  # actionable?
  # Is it worth printing out an invoice for this record?
  # products have to be created before this method returns expected values
  #
  def actionable?
    products.balanced
    products.total_arrears > 0
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

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "client: #{client_address.inspect}"
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

  def generate_comments(comments:)
    comments.reject(&:blank?).map { |comment| Comment.new clarify: comment }
  end
end
