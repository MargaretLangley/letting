require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe AccountDebit, type: :model do
  it 'uses <=> for equality' do # requires comparable
    lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    expect(lhs == rhs).to eq true
  end
  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      expect(lhs <=> rhs).to eq(0)
    end

    describe 'returns 1 when lhs > rhs' do
      it 'compares date_due' do
        lhs = AccountDebit.new date_due: '2014-02-01', charge_type: 'Ins', property_ref: 4, amount: 6
        rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares charge_type' do
        lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'ZZZ', property_ref: 4, amount: 6
        rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares property ref' do
        lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 5, amount: 7
        rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 7
        expect(lhs <=> rhs).to eq(1)
      end

      it 'does not compares amount' do
        lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 7
        rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(0)
      end

      it 'compares date due before charge_type' do
        lhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'ZZZ', property_ref: 4, amount: 7
        rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 7
        expect(lhs <=> rhs).to eq(1)
      end
    end

    it 'returns -1 when lhs < rhs' do
      lhs = AccountDebit.new date_due: '2013-12-31', charge_type: 'Rent', property_ref: 4, amount: 6
      rhs = AccountDebit.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      lhs = AccountDebit.new(date_due: '2013-12-31', charge_type: 'Rent', property_ref: 4, amount: 6)
      expect(lhs <=> 37).to be_nil
    end
  end
end
