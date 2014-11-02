###
# InvoiceAccount
#
# Link between the invoices, up to 2, and the debits which the
# invoices are responsible. The idea is to only delete the
# debits if both invoices are deleted.
#
# http://stackoverflow.com/questions/6301054/check-all-associations-before-destroy-in-rails
# http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
#
###
#
class InvoiceAccount < ActiveRecord::Base
  has_many :invoices, dependent: :destroy, inverse_of: :invoice_account
  has_many :debits, dependent: :destroy, inverse_of: :invoice_account
  validates :debits, presence: true

  def debited(debits:)
    self.debits = debits
  end

  def sum
    debits.map(&:amount).inject(0, :+)
  end

  # Want to be able to destroy an invoice and not destroy
  # invoice_account if it has another invoice already
  # Not got the association to work and may just delete
  # as appropriate in the controller
end
