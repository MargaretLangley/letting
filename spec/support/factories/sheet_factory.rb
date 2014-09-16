# rubocop: disable Metrics/ParameterLists

def sheet_new id: 4,
              description: 'Page 1 Invoice',
              invoice_name: 'Bell',
              phone: '01710008',
              vat: '89'
  Sheet.new id: id,
            description: description,
            invoice_name: invoice_name,
            phone: phone,
            vat: vat
end

def sheet_create(id:, description:, invoice_name:, phone:, vat:, heading2:)
  Sheet.create! id: id,
                description: description,
                invoice_name: invoice_name,
                phone: phone,
                vat: vat,
                heading2: heading2
end
