# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength
# rubocop: disable Lint/UnusedMethodArgument

# invoice_new and invoice_create require that a template with id 1 has been
# created BEFORE invoice.prepare is called.
# By default the factory creates the template
# With the method argument: templates: [template_create(id: 1)]

def invoice_new id: id,
                invoice_date: '2014/06/30',
                account: account_new(property: property_new),
                property_address: address_new,
                property_ref: 108,
                client: "Lord Harris\nNew Road\nEdge\nBrum",
                arrears: 20.20,
                debits: [debit_new(charge: charge_new)],
                templates: [template_create(id: 1)]

  account.property.human_ref = property_ref
  account.property.address = property_address

  invoice = Invoice.new id: id
  invoice.prepare invoice_date: invoice_date
  invoice.property account.property.invoice
  invoice.account arrears: arrears,
                  total_arrears: (arrears.to_i + 30),
                  debits: debits
  invoice.client client: client
  invoice.arrears = arrears
  if debits
    invoice.products = debits.map { |debit| Product.new debit.to_debitable }
  end
  invoice
end

def invoice_create id: nil,
                   invoice_date: '2014/06/30',
                   account: account_new(property: property_new),
                   property_address: address_new,
                   property_ref: 108,
                   client: "Lord Harris\nNew Road\nEdge\nBrum",
                   arrears: 20.20,
                   debits: [debit_new(charge: charge_new)],
                   templates: [template_create(id: 1)]
  invoice = invoice_new id: id,
                        invoice_date: invoice_date,
                        account: account,
                        property_address: property_address,
                        property_ref: property_ref,
                        client: client,
                        arrears: arrears,
                        debits: debits,
                        templates: templates
  invoice.save!
  invoice
end
