require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6,
                        period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

      rhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6,
                        period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

      expect(lhs <=> rhs).to eq(0)
    end

    describe 'returns 1 when lhs > rhs' do
      it 'compares charge_type' do
        lhs = Product.new charge_type: 'ZZZ', date_due: '2014-01-01', amount: 6,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        rhs = Product.new charge_type: 'Ins', date_due: '2014-01-01', amount: 6,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares date_due' do
        lhs = Product.new charge_type: 'Ins', date_due: '2014-02-01', amount: 6,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        rhs = Product.new charge_type: 'Ins', date_due: '2014-01-01', amount: 6,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares amount' do
        lhs = Product.new charge_type: 'Ins', date_due: '2014-01-01', amount: 7,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        rhs = Product.new charge_type: 'AAA', date_due: '2014-01-01', amount: 6,
                          period: Date.new(2014, 1, 1)..Date.new(2014, 3, 1)

        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares period' do
        lhs = Product.new charge_type: 'Ins', date_due: '2014-01-01', amount: 7,
                          period: Date.new(2010, 1, 1)..Date.new(2010, 3, 1)

        rhs = Product.new charge_type: 'Ins', date_due: '2014-01-01', amount: 7,
                          period: Date.new(1999, 1, 1)..Date.new(1999, 3, 1)

        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares charge_type before period' do
        lhs = Product.new charge_type: 'ZZZ', date_due: '2014-01-01', amount: 7,
                          period: Date.new(1999, 1, 1)..Date.new(1999, 3, 1)

        rhs = Product.new charge_type: 'AAA', date_due: '2014-01-01', amount: 7,
                          period: Date.new(2010, 1, 1)..Date.new(2010, 3, 1)

        expect(lhs <=> rhs).to eq(1)
      end
    end

    it 'returns -1 when lhs < rhs' do
      lhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 5
      rhs = Product.new charge_type: 'Rent', date_due: '2014-01-01', amount: 6
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(Product.new <=> 37).to be_nil
    end
  end
end
