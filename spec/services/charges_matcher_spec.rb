require 'spec_helper'

module DB
  describe ChargesMatcher do

    let(:charges) { account_and_charge_new.charges }

    context '#first_or_initialize' do
      it 'empty charge if unknown' do
        expect(ChargesMatcher.new(charges)
                             .first_or_initialize 'first seen')
                             .to be_empty
      end

      it 'matching charge if known' do
        expect(ChargesMatcher.new(charges)
                             .first_or_initialize 'Ground Rent')
                             .to be_present
      end
    end

    context '#find' do
      it 'nil if unknown' do
        expect(ChargesMatcher.new(charges).find 'unknown').to be_nil
      end

      it 'present if known' do
        expect(ChargesMatcher.new(charges).find 'Ground Rent')
          .to be_present
      end
    end

    context '#find!' do
      it 'present if known' do
        expect(ChargesMatcher.new(charges).find! 'Ground Rent')
          .to be_present
      end

      it 'exception if unknown' do
        property = property_with_charge_create!
        charges = property.account.charges
        expect { ChargesMatcher.new(charges).find! 'unknown' }
          .to raise_error ChargeUnknown, "Charge 'unknown' not found " +
                                         "in property '2002'"
      end

      it 'property, account or human_ref nil' do
        expect { ChargesMatcher.new(charges).find! 'unknown' }
          .to raise_error ChargeUnknown,
                          "Charge 'unknown' not found in property 'unknown'"
      end
    end
  end
end
