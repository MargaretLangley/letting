require 'rails_helper'

describe Credit, :ledgers, type: :model do

  let(:credit) { credit_new amount: -88.08 }

  describe 'validates' do
    describe 'presence' do
      it('is not valid') { expect(credit_new).to_not be_valid }
      it('is valid with charge') do
        expect(credit_new charge: charge_new).to be_valid
      end
      it 'charge required but missing' do
        (credit = credit_new).valid?
        expect(credit.errors.first).to eq [:charge, "can't be blank"]
      end
      it 'on_date' do
        (credit = credit_new).on_date = nil
        expect(credit).to_not be_valid
      end
    end
    describe 'amount' do
      it('is a number') { expect(credit_new amount: 'nan').to_not be_valid }
      it 'has a max' do
        expect(credit_new charge: charge_new, amount: 100_000).to_not be_valid
      end
      it('is valid under max') do
        expect(credit_new charge: charge_new, amount: 99_999.99).to be_valid
      end
      it('has a min') { expect(credit_new amount: -100_000).to_not be_valid }
      it('is valid under min') do
        expect(credit_new charge: charge_new, amount: -99_999.99).to be_valid
      end
      it 'fails zero amount' do
        expect(credit_new charge: charge_new, amount: 0).to_not be_valid
      end
    end
  end

  context 'default initialize' do
    before { Timecop.travel Date.new(2013, 9, 30) }
    after { Timecop.return }

    it 'has on_date' do
      expect(credit_new(on_date: nil).on_date.to_s)
        .to eq Time.zone.local(2013, 9, 30, 0, 0, 0, '+1').to_s
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'orders credits by date' do
        last  = credit_new on_date: Date.new(2013, 4, 1)
        first = credit_new on_date: Date.new(2012, 4, 1)
        charge = charge_create credits: [last, first]

        expect(Credit.available charge.id).to eq [first, last]
      end
    end
  end

  describe 'methods' do

    describe '#charge_type' do
      it 'returned when charge present' do
        (credit = credit_new).charge = charge_new charge_type: 'Rent'
        expect(credit.charge_type).to eq 'Rent'
      end

      it 'errors when charge missing' do
        expect { credit_new(charge: nil).charge_type }.to raise_error
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(credit_new.outstanding).to eq(88.08)
      end

      it 'multiple credits are added' do
        charge = charge_create(debits:  [debit_new(amount: 4.00)],
                               credits: [credit_new(amount: -6.00)])
        charge.save!
        expect(Credit.first.outstanding).to eq(2.00)
      end
    end

    describe '#spent?' do
      it 'false without credit' do
        expect(credit_create charge: charge_new, amount: (-88.07))
          .to_not be_spent
      end

      it 'true when spent' do
        charge = charge_new(debits:  [debit_new(amount: 8.00)],
                            credits: [credit_new(amount: -8.00)])
        charge.save!
        expect(Credit.first).to be_spent
      end
    end
    describe '#negate' do
      it 'amount sign change' do
        (credit = credit_new(amount: -40)).negate
        expect(credit.amount).to eq 40
      end
    end
  end
end
