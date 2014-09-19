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
#   - Invoice Type  (GR Ins, Service Charge etc)
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
class Invoice < ActiveRecord::Base
  def prepare(invoice_date:, account:)
    # self.agent = < agent name and address >
    self.property_ref = account.property.human_ref
    self.invoice_date = invoice_date

    self.property_address = account.property.address.text

    self.arrears = account.balance
    # items
    # self.total_arrears = < sum >
    self.client = account.property.client.full_name +
                  account.property.client.address.text
    self
  end
end
