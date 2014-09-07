require 'rails_helper'

describe Credit, :ledgers, type: :model do

  let(:credit) { credit_new amount: -88.08 }
  it('is valid') { expect(credit).to be_valid }

  describe 'validates' do
    describe 'presence' do
      it('charge_id') { expect(credit_new(charge_id: nil)).to_not be_valid }
      it 'on_date' do
        credit.on_date = nil
        expect(credit).to_not be_valid
      end
      it('amount') { expect(credit_new(amount: nil)).to_not be_valid }
    end

    describe 'amount' do
      it('is a number') { expect(credit_new(amount: 'nan')).to_not be_valid }
      it('has a max') { expect(credit_new(amount: 0)).to_not be_valid }
      it('is valid under max') { expect(credit_new(amount: -0.01)).to be_valid }
      it('has a min') { expect(credit_new(amount: -100_000)).to_not be_valid }
      it('is valid under min') do
        expect(credit_new(amount: -99_999.99)).to be_valid
      end
    end
  end

  context 'default inialization' do
    let(:credit) do
      debit = Debit.create! debit_attributes
      debit.credits.build
    end
    before { Timecop.travel(Date.new(2013, 9, 30)) }
    after { Timecop.return }

    it 'has on_date' do
      expect(credit.on_date).to eq Date.new 2013, 9, 30
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'orders credits by date' do
        last  = credit_create on_date: Date.new(2013, 4, 1)
        first = credit_create on_date: Date.new(2012, 4, 1)
        expect(Credit.available first.charge_id).to eq [first, last]
      end
    end
  end

  context 'methods' do

    context '#charge_type' do
      it 'returned when charge present' do
        (credit = credit_new).charge = charge_new charge_type: 'Rent'
        expect(credit.charge_type).to eq 'Rent'
      end

      it 'errors when charge missing' do
        expect { credit_new(charge: nil).charge_type }.to raise_error
      end
    end

    context '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(credit_new.outstanding).to eq(88.08)
      end

      it 'multiple credits are added' do
        credit = credit_new amount: -6.00
        Debit.create! debit_attributes amount: 4.00
        credit.save!
        expect(credit.outstanding).to eq(2.00)
      end
    end

    describe '#spent?' do
      it 'false without credit' do
        expect(credit_create amount: (-88.07)).to_not be_spent
      end

      it 'true when spent' do
        credit = credit_create amount: (-8.00)
        Debit.create! debit_attributes amount: 8.00
        credit.save!
        expect(credit).to be_spent
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
