require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_payment'

module DB
  describe ImportPayment, :import do

    it 'with debit' do
      credit = credit_with_stubbed_charge_type credit_new,
                                               'Ground Rent'
      payment_with_stubbed_credit credit
      property_create! human_ref: 89

      expect_import_to change(Credit, :count).by 1
    end

    it 'in advance' do
      credit = credit_with_stubbed_charge_type credit_in_advance_new,
                                               'Ground Rent'
      payment_with_stubbed_credit credit
      property_create! human_ref: 89

      expect_import_to change(Credit, :count).by 1
    end

    context 'errors' do
      it 'without charge_type raises error' do
        credit = credit_with_stubbed_charge_type credit_in_advance_new,
                                                 'service_charge'
        payment_with_stubbed_credit credit
        property_create! human_ref: 89

        expect_import_to raise_error DB::ChargeTypeUnknown
      end

      it 'double import raises error' do
        credit = credit_with_stubbed_charge_type credit_in_advance_new,
                                                 'Ground Rent'
        payment_with_stubbed_credit credit
        property_create! human_ref: 89

        ImportPayment.import parse credit_row
        expect_import_to raise_error NotIdempotent
      end
    end

    def credit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end

    def expect_import_to match
      expect { ImportPayment.import parse credit_row }.to match
    end

    def payment_with_stubbed_credit credit
      Payment.any_instance.stub(:prepare_accounts_credits).and_return [ credit ]
    end

    def credit_with_stubbed_charge_type credit, charge_type
        credit.stub(:type).and_return charge_type
        credit
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end
  end
end
