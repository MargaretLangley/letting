require 'rails_helper'

#
# specs for testing the products collection
#
#
RSpec.describe 'Products', type: :model do
  describe '#balanced' do
    it 'returns a balance' do
      invoice = Invoice.new products: [product_new(amount: 30)]
      invoice.products.balanced
      expect(invoice.total_arrears).to eq 30
    end

    it 'sums the balance' do
      invoice = Invoice.new products: [product_new(amount: 30),
                                       product_new(amount: 40)]
      invoice.products.balanced
      expect(invoice.total_arrears).to eq 70
    end
  end

  describe '#drop_arrears' do
    it 'removes arrears from products' do
      invoice =
        Invoice.new products: [product_new(charge_type: ChargeTypes::ARREARS),
                               product_new(charge_type: ChargeTypes::INSURANCE)]
      products = invoice.products.drop_arrears

      expect(products.first.charge_type).to_not eq 'Arrears'
      expect(products.first.charge_type).to eq 'Insurance'
    end

    it 'leaves anything not to do with arrears' do
      invoice =
        Invoice.new products: [product_new(charge_type: ChargeTypes::INSURANCE)]
      products = invoice.products.drop_arrears

      expect(products.first.charge_type).to eq 'Insurance'
    end
  end

  describe '#total_arrears' do
    it 'returns zero when no products' do
      invoice = Invoice.new products: []
      invoice.products.balanced
      expect(invoice.total_arrears).to eq 0
    end

    it 'returns sum of product arrears' do
      invoice = Invoice.new products: [product_new(amount: 30)]
      invoice.products.balanced
      expect(invoice.total_arrears).to eq 30
    end
  end
end
