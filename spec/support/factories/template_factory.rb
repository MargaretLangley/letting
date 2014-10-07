# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def template_new id: nil,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Bell',
                 phone: '01710008',
                 vat: '89',
                 heading1: 'Heads up',
                 address: address_new
  Template.new id: id,
               description: description,
               invoice_name: invoice_name,
               phone: phone,
               vat: vat,
               heading1: heading1,
               address: address
end

def template_create(id: 1,
                    description: 'Page 1 Invoice',
                    invoice_name: 'Bell',
                    phone: '01710008',
                    vat: '89',
                    heading1: 'Heads up',
                    address: address_new)
  Template.create! id: id,
                   description: description,
                   invoice_name: invoice_name,
                   phone: phone,
                   vat: vat,
                   heading1: heading1,
                   address: address
end
