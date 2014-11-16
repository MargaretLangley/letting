# rubocop: disable Metrics/ParameterLists, Metrics/MethodLength, Metrics/LineLength
# rubocop: disable Lint/UnusedMethodArgument

# invoice_new and invoice_create require that a template with id 1 has been
# created BEFORE invoice.prepare is called.
# By default the factory creates the template
# With the method argument: templates: [template_create(id: 1)]

def invoice_new id: id,
                run_id: 5,
                invoice_date: '2014/06/30',
                account: account_create,
                property: property_new,
                invoice_account: invoice_account_new

  template_create(id: 1) unless Template.find_by id: 1
  account.property = property
  invoice = Invoice.new id: id, run_id: run_id
  invoice.prepare account: account,
                  invoice_date: invoice_date,
                  property: account.property.invoice,
                  billing: { arrears: 0, transaction: invoice_account }
  invoice
end

def invoice_create \
  id: nil,
  run_id: 6,
  invoice_date: '2014/06/30',
  account: account_new(property: property_new),
  property: property_new,
  invoice_account: invoice_account_new

  invoice = invoice_new id: id,
                        run_id: run_id,
                        invoice_date: invoice_date,
                        account: account,
                        property: property,
                        invoice_account: invoice_account
  invoice.save!
  invoice
end
