require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe InvoiceRemaker, type: :model do
  describe '#compose' do
    it 'makes a new invoice' do
      remaker = InvoiceRemaker.new template_invoice: invoice_new,
                                   invoice_date: Date.new(2001, 1, 1),
                                   products: []
      expect(remaker.compose.to_s)
        .to eq [%q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands"),
                %q(Property Ref: 2002),
                %q(Invoice Date: Mon, 01 Jan 2001),
                %q(Property Address: "Edgbaston Road\nBirmingham\nWest Midlands"),
                %q(client: "")].join "\n"

      # %q - act as single quote  \n => \\n
      # %Q - act as double quote  \n =  \n
    end
  end
end
