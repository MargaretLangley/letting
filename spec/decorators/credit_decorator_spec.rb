require 'spec_helper'

describe CreditDecorator do

  let(:credit) { CreditDecorator.new credit_new }

  context '#clear_up_form' do
    it '0 amount to be destroyed' do
      credit.amount = 0.0
      credit.clear_up
      expect(credit).to be_marked_for_destruction
    end
    it 'none 0 amount to be persisted' do
      credit.amount = 80.0
      credit.clear_up
      expect(credit).to_not be_marked_for_destruction
    end
  end

end