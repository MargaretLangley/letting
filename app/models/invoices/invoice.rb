# Invoice Requires
#
# Invoice contains the dynamic data needed to make an invoice.
# Invoice works with the static date (invoice_text) to create a viewable and
# printable invoice.
#
# Invoices are created during a run by the invoices_maker.
#
# An Invoice is made of:
#
# property
#  - property_ref (human_ref)
#  - occupiers (name of tenant)
#  - property_address (building's address)
#  - billing_address (agent or building's address)
#  - client_address
#
# snapshot
#   - Product (Invoice line item)
#      - charge_type
#      - date_due
#      - automatic_payment
#      - amount
#      - period (period_first..period_last) - period the charge covers.
#
# invoice_date - date the invoice is made on.
# comments - one off information to be read by the bill's addressee.
#
class Invoice < ActiveRecord::Base
  enum deliver: [:mail, :retain, :forget]
  belongs_to :run, inverse_of: :invoices
  belongs_to :snapshot, autosave: true, inverse_of: :invoices
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

    def drop_arrears
      reject { |product| product.charge_type == 'Arrears' }
    end

    def total_arrears
      return 0 if last.nil?

      last.balance
    end
  end
  validates :invoice_date, :property_ref, :property_address, presence: true
  has_many :invoice_texts, through: :letters
  has_many :letters, dependent: :destroy

  after_destroy :destroy_orphaned_snapshot

  delegate :earliest_date_due, to: :products

  def total_arrears
    products.balanced
    products.total_arrears
  end

  # prepare
  # Assigns the attributes required in an invoice
  # Args:
  # property      - property that the invoice is being prepared for
  # invoice_date  - the date which this invoice is being said to have been sent.
  # snapshot      - debits generated for the invoicing period
  # comments      - array of strings to appear on invoice for special info.
  #
  def prepare property:, snapshot:, invoice_date: Time.zone.today, comments: []
    letters.build invoice_text: InvoiceText.first
    self.property = property
    self.snapshot = snapshot
    self.products = snapshot.products invoice_date: invoice_date
    self.deliver = snapshot.state
    self.invoice_date = invoice_date
    self.comments = generate_comments comments: comments
    self
  end

  def mail?
    deliver == 'mail'
  end

  def retain?
    deliver == 'retain'
  end

  def forget?
    deliver == 'forget'
  end

  def page2?
    blue_invoice? && products.any?(&:page2?)
  end

  # actionable?
  # Is it worth invoicing or not. Must be one or more property that will
  # be affected by a charge.
  #
  def actionable?
    mail? || retain?
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "client: #{client_address.inspect}"
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

  def property=(property_ref:, occupiers:, property_address:, billing_address:, client_address:) # rubocop: disable Metrics/LineLength
    self.property_ref = property_ref
    self.occupiers = occupiers
    self.property_address = property_address
    self.billing_address = billing_address
    self.client_address = client_address
  end

  # If we destroy the invoice we destroy the associated snapshot if there is
  # no other invoice reference to it.
  #
  def destroy_orphaned_snapshot
    snapshot.invoices.empty? && snapshot.destroy
  end

  # First Invoice for a set of debited charges (red invoice is the second)
  #
  def blue_invoice?
    snapshot.only_one_invoice?
  end

  def generate_comments(comments:)
    comments.reject(&:blank?).map { |comment| Comment.new clarify: comment }
  end
end
