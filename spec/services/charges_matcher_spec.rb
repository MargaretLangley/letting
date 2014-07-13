require 'spec_helper'

module DB
  describe ChargesMatcher do

    describe '#first_or_initialize' do
      it 'builds a charge if the charge type is unknown' do
        charges = account_and_charge_new(
                  charge_attributes: { charge_type: 'Rent' }
                  ).charges
        (matcher = ChargesMatcher.new(charges)).first_or_initialize 'Unknown'
        expect(matcher.size).to eq(2)
      end

      it 'returns the first matching charge' do
        charges = account_and_charge_new(
                  charge_attributes: { charge_type: 'Rent' }
                  ).charges
        (matcher = ChargesMatcher.new(charges)).first_or_initialize 'Rent'
        expect(matcher.size).to eq(1)
      end
    end
  end
end
