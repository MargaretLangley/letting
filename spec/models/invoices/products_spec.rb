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

    it 'balance includes any current arrears' do
      invoice = Invoice.new products: [product_new(amount: 30)]
      invoice.products.balanced total: 10
      expect(invoice.total_arrears).to eq 40
    end
  end

  describe '#total_arrears' do
    it 'returns arrears' do
      invoice = Invoice.new products: [product_new(amount: 30)]
      invoice.products.balanced total: 10
      expect(invoice.total_arrears).to eq 40
    end
  end
end
