require 'spec_helper'

describe Credit do

  let(:credit) { Credit.new credit_attributes }
  it('is valid') { expect(credit).to be_valid }

  context 'validates' do
    context 'presence' do
      it 'debit_id' do
        credit.debit_id = nil
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

end
