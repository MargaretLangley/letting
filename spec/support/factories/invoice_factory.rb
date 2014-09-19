# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def invoice_new invoice_date: '2014/06/30',
                account: account_new,
                property: property_new,
                property_ref: 108,
                client_name: 'Lord Harris',
                client_address: "New Road\nEdge\nBrum",
                arrears: 20.20
  property.human_ref = property_ref if property_ref
  property.account = account
  client = client_new
  client.entities = [Entity.new(name: client_name)] if client_name
  client.properties << property

  invoice = Invoice.new
  invoice.prepare invoice_date: invoice_date,
                  account: property.account
  invoice.property_ref = property_ref
  invoice.client_name = client_name
  invoice.client_address = client_address
  # ,
  #             arrears: arrears
  invoice
end
