###
# DebitsTransaction
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
class DebitsTransaction < ActiveRecord::Base
  has_many :invoices, dependent: :destroy, inverse_of: :debits_transaction
  has_many :debits, dependent: :destroy, inverse_of: :debits_transaction
  validates :debits, presence: true

  def debited(debits:)
    self.debits = debits
  end

  def sum
    debits.map(&:amount).inject(0, :+)
  end

  def debits?
    debits.any?
  end

  def only_one_invoice?
    invoices.size <= 1
  end

  # Want to be able to destroy an invoice and not destroy
  # debits_transaction if it has another invoice already
  # Not got the association to work and may just delete
  # as appropriate in the controller
end
