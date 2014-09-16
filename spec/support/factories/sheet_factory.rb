# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def sheet_new id: nil,
              description: 'Page 1 Invoice',
              invoice_name: 'Bell',
              phone: '01710008',
              vat: '89',
              heading2: nil,
              address: address_new
  Sheet.new id: id,
            description: description,
            invoice_name: invoice_name,
            phone: phone,
            vat: vat,
            heading2: heading2,
            address: address
end

def sheet_create(id: nil,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Bell',
                 phone: '01710008',
                 vat: '89',
                 heading2: nil,
                 address: address_new)
  Sheet.create! id: id,
                description: description,
                invoice_name: invoice_name,
                phone: phone,
                vat: vat,
                heading2: heading2,
                address: address
end
