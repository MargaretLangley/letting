require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe InvoiceMaker, type: :model do
  describe '#compose' do
    it 'invoice accounts within property and due date range' do
      template_create id: 1
      charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account = account_create property: property_new, charges: [charge]

      invoice =
        InvoiceMaker.new account: account,
                         period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                         invoice_date: Date.new(2010, 2, 1),
                         comments: [],
                         transaction: DebitsTransaction.new
      expect(invoice.compose.to_s)
        .to eq [%q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands"),
                %q(Property Ref: 2002),
                %q(Invoice Date: Mon, 01 Feb 2010),
                %q(Property Address: "Edgbaston Road\nBirmingham\nWest Midlands"),
                %q(client: "")].join "\n"

    end

    describe 'products' do
      it 'makes products' do
        template_create id: 1
        account = account_create property: property_new
        (transaction = DebitsTransaction.new)
          .debited debits: [debit_new(amount: 20, charge: charge_new)]

        invoice =
          InvoiceMaker.new account: account,
                           period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                           comments: [],
                           transaction: transaction

        expect(invoice.compose.products.first.balance).to eq 20.00
      end
    end
  end
end
