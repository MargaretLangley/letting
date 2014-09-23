require 'rails_helper'

RSpec.describe Product, type: :model do
  # TODO: range into comparison
  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6.00
      rhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6.00
      expect(lhs <=> rhs).to eq(0)
    end

    it 'returns 1 when lhs > rhs' do
      lhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 7.00
      rhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6.00
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      lhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 5.00
      rhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6.00
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(Product.new <=> 37).to be_nil
    end
  end
end
