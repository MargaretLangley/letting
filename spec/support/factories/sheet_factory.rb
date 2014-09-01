# rubocop: disable Style/ParameterLists

def sheet_create(id:, description:, invoice_name:, phone:, vat:, heading2:)
  Sheet.create! id: id,
                description: description,
                invoice_name: invoice_name,
                phone: phone,
                vat: vat,
                heading2: heading2
end
