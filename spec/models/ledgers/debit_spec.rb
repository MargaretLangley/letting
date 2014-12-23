# rubocop: disable  Lint/UselessComparison
require 'rails_helper'

describe Debit, :ledgers, type: :model do
  describe 'validates' do
    let(:debit) { charge_new(debits: [debit_new]).debits.first }
    it('is valid') { expect(debit).to be_valid }
    describe 'presence' do
      it 'charge required but missing' do
        (debit = debit_new).valid?
        expect(debit.errors.first).to eq [:charge, "can't be blank"]
      end
      it 'on_date' do
        debit.on_date = nil
        expect(debit).to_not be_valid
      end
      it('amount') { debit_new amount: nil }
    end
    describe 'amount' do
      it('is a number') { expect(debit_new(amount: 'nan')).to_not be_valid }
      it 'has a max' do
        expect(debit_new(charge: charge_new, amount: 100_000)).to_not be_valid
      end
      it('is valid under max') do
        debit.amount = 99_999.99
        expect(debit).to be_valid
      end
      it 'has a min' do
        expect(debit_new(charge: charge_new, amount: -100_000)).to_not be_valid
      end
      it('is valid under max') do
        debit.amount = -99_999.99
        expect(debit).to be_valid
      end
      it('fails zero amount') { expect(debit_new amount: 0).to_not be_valid }
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'orders debits by date' do
        last  = debit_new on_date: Date.new(2013, 4, 1)
        first = debit_new on_date: Date.new(2012, 4, 1)
        charge = charge_create debits: [last, first]

        expect(Debit.available charge.id).to eq [first, last]
      end
    end
  end

  describe 'methods' do
    describe '#charge_type' do
      it 'returned when charge present' do
        (debit = debit_new).charge = charge_new charge_type: 'Rent'
        expect(debit.charge_type).to eq 'Rent'
      end

      it 'errors when charge missing' do
        expect { debit_new.charge_type }.to raise_error
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(debit_new.outstanding).to eq 88.08
      end

      it 'multiple credits are added' do
        charge = charge_create(debits:  [debit_new(amount: 88.08)],
                               credits: [credit_new(amount: -44.04)])
        charge.save!
        expect(Debit.first.outstanding).to eq 44.04
      end
    end

    describe '#paid?' do
      it 'false without credit' do
        charge = charge_new debits: [debit_new(amount: 88.08)]
        charge.save!
        expect(Debit.first).to_not be_paid
      end

      it 'true when paid in full' do
        charge = charge_new(debits:  [debit_new(amount: 88.08)],
                            credits: [credit_new(amount: -88.08)])
        charge.save!
        expect(Debit.first).to be_paid
      end
    end

    describe 'to_debitable' do
      it 'makes hash' do
        expect(debit_new(charge: charge_new).to_debitable)
          .to eq charge_type: ChargeTypes::GROUND_RENT,
                 automatic_payment: false,
                 date_due: Time.zone.local(2013, 3, 25, 0, 0, 0, '+0'),
                 period: Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
                 amount: 88.08
      end
    end

    describe '#<=>' do
      it 'returns 0 when equal' do
        lhs = debit_new charge_id: 1, on_date: '2014-01-02', amount: 5.00
        rhs = debit_new charge_id: 1, on_date: '2014-01-02', amount: 5.00
        expect(lhs <=> rhs).to eq(0)
      end

      it 'returns 1 when lhs > rhs' do
        lhs = debit_new charge_id: 1, on_date: '2014-01-02', amount: 6.00
        rhs = debit_new charge_id: 1, on_date: '2014-01-02', amount: 5.00
        expect(lhs <=> rhs).to eq(1)
      end

      it 'returns -1 when lhs < rhs' do
        lhs = debit_new charge_id: 1, on_date: '2014-01-02', amount: 5.00
        rhs = debit_new charge_id: 2, on_date: '2014-01-02', amount: 5.00
        expect(lhs <=> rhs).to eq(-1)
      end

      it 'returns nil when not comparable' do
        expect(debit_new <=> 37).to be_nil
      end
    end

    describe '#to_s' do
      it 'without charge' do
        expect(debit_new.to_s)
          .to eq 'id: nil, ' \
                 'charge_id: nil, ' \
                 'on_date: 2013-03-25+t, ' \
                 'period: 2013-03-25..2013-06-30, ' \
                 'amount: 88.08, ' \
                 'charge: nil'
      end

      it 'with charge' do
        expect(debit_new(charge: charge_new).to_s)
          .to end_with 'charge_type: Ground Rent auto: nil '
      end
    end
  end
end
