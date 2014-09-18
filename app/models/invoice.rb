# Invoice Data
#
# Invoice Date
# Total Owing
# Client
#   - Name, client address
# Property
#   - Property Ref
#   - Occupier's name & Address
#   - Agent
#     - Name & address
#
# Invoiceable (data for each invoice item)
#   - Invoice Type  (GR Ins, Service Charge etc)
#   - Date Due
#   - Description
#   - Amount
#   - Balance
#   - Time Period the charge covers
#
#  Arrears
#   - Total arrears (not even date)
#
class Invoice < ActiveRecord::Base
  include Contact

  # Client  Name, client address
end
