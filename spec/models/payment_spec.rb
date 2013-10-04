require 'spec_helper'

describe Payment do

  let(:payment) { Payment.new payment_attributes }
  it('is valid') { expect(payment).to be_valid }

  context 'validates' do
    context 'presence' do
      it 'debt_id' do
        payment.debt_id = nil
        expect(payment).to_not be_valid
      end
      it 'on_date' do
        payment.on_date = nil
        expect(payment).to_not be_valid
      end
    end

    context 'amount' do
      it 'One penny is valid' do
        payment.amount = 0.01
        expect(payment).to be_valid
      end

      it 'two digits only' do
        payment.amount = 0.00001
        expect(payment).to_not be_valid
      end

      it 'positive numbers' do
        payment.amount = -1.00
        expect(payment).to_not be_valid
      end
    end
  end
end
