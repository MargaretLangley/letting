# rubocop: disable Style/ParameterLists

require 'rails_helper'

def sheet_create(id:, description:, invoice_name:, phone:, vat: vat, heading2:)
  Sheet.create! id: id,
                description: description,
                invoice_name: invoice_name,
                phone: phone,
                vat: vat,
                heading2: heading2
end
