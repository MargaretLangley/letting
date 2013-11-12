require 'spec_helper'

describe Credit do

  let(:credit) { credit_new }
  it('is valid') { expect(credit).to be_valid }

  context 'validates' do
    context 'presence' do
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

      it 'not greater than owed' do
        credit.amount = 88.09
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
    end
  end

  context 'associations' do
    it('has payment') { expect(credit).to respond_to :payment }
    it('has account') { expect(credit).to respond_to :account }
    it('has debit') { expect(credit).to respond_to :debit }
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
    it '#outstanding calculated' do
      expect(credit.outstanding).to eq 88.08
    end

    context '#pay_off calculates' do
      it 'new record correctly' do
        expect(credit.pay_off).to eq 88.08
      end
      it 'saved record correctly' do
        credit.should_receive(:new_record?).and_return(false)
        expect(credit.pay_off).to eq 176.16
      end
    end
  end
end
