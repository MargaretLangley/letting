require 'rails_helper'

describe 'payment' do

  describe 'payment_new' do
    describe 'default' do
      it('is valid') { expect(payment_new).to be_valid }
    end

    describe 'override' do
      it 'on date' do
        expect(payment_new(on_date: '2012-03-25').on_date)
          .to eq Date.new(2012, 03, 25)
      end
      it('changes amount') { expect(payment_new(amount: 1).amount).to eq 1 }
    end

    describe 'adds' do
      it 'credits' do
        payment = payment_new credit: credit_new
        expect(payment.credits.size).to eq 1
      end
    end
  end
end
