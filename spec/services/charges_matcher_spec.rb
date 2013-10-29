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
        expect(ChargesMatcher.new(charges).find 'Ground Rent').to \
          be_present
      end
    end

    context '#find!' do
      it 'exception if unknown' do
        expect { ChargesMatcher.new(charges).find! 'unknown' }.to \
          raise_error ChargeUnknown
      end

      it 'present if known' do
        expect(ChargesMatcher.new(charges).find! 'Ground Rent').to \
          be_present
      end
    end
  end
end
