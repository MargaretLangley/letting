require 'rails_helper'
require_relative '../../../lib/import/payment_type'
include PaymentTypeDefaults
# rubocop: disable Style/Documentation

module DB
  describe PaymentType, :import do
    describe '.to_symbol' do
      it 'maps standing order' do
        expect(PaymentType.to_symbol 'S'.to_sym).to eq AUTOMATIC
      end

      it 'maps payments P' do
        expect(PaymentType.to_symbol 'P'.to_sym).to eq PAYMENT
      end

      it 'maps payments L' do
        expect(PaymentType.to_symbol 'L'.to_sym).to eq PAYMENT
      end

      it 'maps unknown payments' do
        expect(PaymentType.to_symbol 'F'.to_sym).to eq UNKNOWN_PAYMENT_TYPE
      end
    end
  end
end
