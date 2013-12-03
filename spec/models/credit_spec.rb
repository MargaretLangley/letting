require 'spec_helper'

describe Credit do

  let(:credit) { credit_new }
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

      it 'One penny is valid' do
        credit.amount = 0.01
        expect(credit).to be_valid
      end

      it 'two digits only' do
        credit.amount = 0.00001
        expect(credit).to_not be_valid
      end

      it 'positive numbers' do
        credit.amount = -1.00
        expect(credit).to_not be_valid
      end

      context 'credit associated with debit' do
        it 'valid below or equal to pay_off' do
          credit.stub(:pay_off_debit).and_return 100
          credit.amount = 100
          expect(credit).to be_valid
        end
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

  context 'methods' do

    context '#pay_off_debit' do
      it 'new record has nothing to pay' do
        credit = Credit.new credit_attributes amount: nil
        expect(credit.pay_off_debit).to eq 0.00
      end
      it 'credit has to pay off debit' do
        credit = Credit.new credit_attributes amount: nil
        credit.debit = Debit.new debit_attributes amount: 10.50
        expect(credit.pay_off_debit).to eq 10.50
      end
    end
    context '#type' do
      it 'returned when charge present' do
        credit.charge = Charge.new charge_attributes
        expect(credit.charge_type).to eq 'Ground Rent'
      end

      it 'errors when charge missing' do
        expect { credit.charge_type }.to raise_error
      end
    end
  end
end
