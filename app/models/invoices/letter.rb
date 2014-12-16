####
#
# Letter
#
# Letter is the association between Invoice and InvoiceText
#
####
#
class Letter < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :invoice_text
  validates :invoice, :invoice_text, presence: true
end
