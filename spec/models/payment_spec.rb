require 'spec_helper'

describe Payment do

  let(:payment) { Payment.new payment_attributes }
  it('is valid') { expect(payment).to be_valid }

  context 'validation' do
    it 'requires account' do
      payment.account_id = nil
      expect(payment).to_not be_valid
    end
    it 'requires amount' do
      payment.account = nil
      expect(payment).to_not be_valid
    end
  end

  context 'associations' do
    it('credits') { expect(payment).to respond_to(:credits) }
  end

end
