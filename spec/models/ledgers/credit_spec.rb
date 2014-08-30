require 'spec_helper'

describe Credit, :ledgers, type: :model do

  let(:credit) { credit_new amount: -88.08 }
  it('is valid') { expect(credit).to be_valid }

  context 'validates' do
    context 'presence' do
      it 'charge_id' do
        credit.charge_id = nil
        expect(credit).to_not be_valid
      end
      it 'on_date' do
        credit.on_date = nil
        expect(credit).to_not be_valid
      end
      it 'amount' do
        credit.amount = nil
        expect(credit).to_not be_valid
      end
    end

    context 'amount' do
      it 'is a number' do
        credit.amount = 'nnn'
        expect(credit).to_not be_valid
      end

      it 'has a positive limit' do
        credit.amount = 0
        expect(credit).to_not be_valid
      end

      it 'valid beneath positive limit' do
        credit.amount = -0.01
        expect(credit).to be_valid
      end

      it 'has a negative limit' do
        credit.amount = -100_000
        expect(credit).to_not be_valid
      end

      it 'valid above negative limit' do
        credit.amount = -99_000.99
        expect(credit).to be_valid
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

  context 'class method' do
    context '.available' do

      it 'orders credits by date' do
        last  = create_credit Date.new(2013, 4, 1)
        first = create_credit Date.new(2012, 4, 1)
        expect(Credit.available first.charge_id).to eq [first, last]
      end

      def create_credit on_date
        Credit.create! credit_attributes on_date: on_date
      end
    end
  end

  context 'methods' do

    context '#charge_type' do
      it 'returned when charge present' do
        credit.charge = Charge.new charge_attributes
        expect(credit.charge_type).to eq 'Ground Rent'
      end

      it 'errors when charge missing' do
        expect { credit.charge_type }.to raise_error
      end
    end

    context '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(credit.outstanding).to eq(88.08)
      end

      it 'multiple credits are added' do
        credit = credit_new amount: -6.00
        Debit.create! debit_attributes amount: 4.00
        credit.save!
        expect(credit.outstanding).to eq(2.00)
      end
    end

    context '#spent?' do
      it 'false without credit' do
        credit = Credit.create! credit_attributes amount: (-88.07)
        credit.save!
        expect(credit).to_not be_spent
      end

      it 'true when spent' do
        credit = Credit.create! credit_attributes amount: (-8.00)
        Debit.create! debit_attributes amount: 8.00
        credit.save!
        expect(credit).to be_spent
      end
    end
  end
end
