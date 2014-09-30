# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def invoice_new invoice_date: '2014/06/30',
                account: account_new(property: property_new),
                property_address: address_new,
                property_ref: 108,
                client: "Lord Harris\nNew Road\nEdge\nBrum",
                arrears: 20.20,
                products: [product_new]

  account.property.human_ref = property_ref
  account.property.address = property_address

  invoice = Invoice.new
  invoice.prepare invoice_date: invoice_date,
                  account: account
  invoice.client = client
  invoice.arrears = arrears
  invoice.products = products if products
  invoice
end

def invoice_create invoice_date: '2014/06/30',
                   account: account_new(property: property_new),
                   property_address: address_new,
                   property_ref: 108,
                   products: [product_new]
  account.property.human_ref = property_ref
  account.property.address = property_address

  invoice = Invoice.create
  invoice.prepare invoice_date: invoice_date,
                  account: account
  invoice.products = products if products
  invoice.save!
  invoice
end
