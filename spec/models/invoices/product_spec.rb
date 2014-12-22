require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it('is valid') { expect(product_new).to be_valid }

    describe 'presence' do
      it 'requires amount' do
        expect(product_new(amount: nil)).to_not be_valid
      end

      it 'requires amount' do
        expect(product_new(charge_type: nil)).to_not be_valid
      end

      it 'requires amount' do
        expect(product_new(date_due: nil)).to_not be_valid
      end

      it 'requires automatic_payment' do
        expect(product_new(automatic_payment: nil)).to_not be_valid
      end
    end
  end

  describe '.page2' do
    it 'returns back page products' do
      invoice_create products: [product_new(charge_type: 'Ground Rent')]
      expect(Product.page2.charge_type).to eq 'Ground Rent'
    end

    it 'orders Ground Rent before Garage ground rent' do
      invoice_create products: [product_new(charge_type: 'Garage Ground Rent'),
                                product_new(charge_type: 'Ground Rent')]
      expect(Product.page2.charge_type).to eq 'Ground Rent'
    end

    it 'does not return 1st page only products' do
      invoice_create products: [product_new(charge_type: 'Insurance')]
      expect(Product.page2).to be_nil
    end
  end

  describe '#page2?' do
    it 'returns false if products have no ground rent' do
      product = Product.new charge_type: 'Insurance'
      expect(product.page2?).to eq false
    end

    it 'returns true if products includes ground rent' do
      product = Product.new charge_type: 'Ground Rent'
      expect(product.page2?).to eq true
    end

    it 'returns true if products includes garage ground rent' do
      product = Product.new charge_type: 'Garage Ground Rent'
      expect(product.page2?).to eq true
    end
  end

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

  it '#to_s' do
    product = product_new charge_type: 'Rent'
    expect(product.to_s)
      .to eq 'charge_type: Rent date_due: 2014-06-07 amount: 30.05 '\
             'period: 2010-09-30..2011-03-25, balance: '
  end
end
