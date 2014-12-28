####
#
# Run
#
# Represents the data created for for an invoicing printout.
#
# Runs create the invoice for each affected account given the invoicing data.
#
# Each Invoicing is normally printed twice. Between runs the debits, held by
# the snapshot, won't change but the credits, payments, may - seen as product
# arrears.
#
####
#
class Run < ActiveRecord::Base
  belongs_to :invoicing, inverse_of: :runs
  has_many :invoices, dependent: :destroy, inverse_of: :run

  validates :invoice_date, :invoices, presence: true
  after_initialize :init

  # prepare
  # assigns invoice_date and invoices created by the invoices_maker.
  # inovices_maker's arguments are assigned by invoicing.
  #
  # invoice_maker - object creating the associated invoices.
  #
  def prepare(invoices_maker:)
    self.invoice_date = invoice_date
    self.invoices = invoices_maker.invoices
  end

  #
  # actionable?
  # Are the accounts invoiceable?
  # prepare must be called before actionable will return correct result
  #
  def actionable?
    invoices.select(&:actionable?).present?
  end

  def deliver
    invoices.select(&:mail?)
  end

  def retain
    invoices.select(&:retain?)
  end

  def forget
    invoices.select(&:forget?)
  end

  def finished?
    invoices.present?
  end

  private

  def init
    self.invoice_date = Time.zone.today if invoice_date.blank?
  end
end
