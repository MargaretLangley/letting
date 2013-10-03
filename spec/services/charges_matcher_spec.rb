require 'spec_helper'

describe ChargesMatcher do

  let(:charges) { account_and_charge_new.charges }

  context '#first_or_initialize' do
    it 'empty charge if unknown' do
      expect(ChargesMatcher.new(charges).first_or_initialize 'first seen').to \
        be_empty
    end

    it 'matching charge if known' do
      expect(ChargesMatcher.new(charges).first_or_initialize 'Ground Rent').to_not \
        be_empty
    end
  end
end
