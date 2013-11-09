require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_payment'

module DB
  describe ImportPayment, :import do

    it 'imports basic' do
      property_create! human_ref: 89
      expect { ImportPayment.import parse credit_row }.to \
        change(Payment, :count).by 1
      expect(Credit.all).to have(0).items
    end

    it 'imports with debit' do
      (property_with_unpaid_debit human_ref: 89).save!
      expect { ImportPayment.import parse credit_row }.to \
        change(Credit, :count).by 1
    end

    it 'double import raises error' do
      (property_with_unpaid_debit human_ref: 89).save!
      ImportPayment.import parse credit_row
      expect { ImportPayment.import parse credit_row }.to \
        raise_error NotIdempotent
    end

    context 'two payments same day' do
      def payment_later_in_day
        %q[89, GR, 2012-03-25 14:01:00, Payment Ground Rent, 0, 20, 0]
      end

      it 'import two credits on one debit' do
        (property_with_unpaid_debit human_ref: 89).save!
        ImportPayment.import parse credit_row
        ImportPayment.import parse payment_later_in_day
        expect(Payment.all).to have(2).items
        expect(Credit.all).to have(2).items
      end
    end

    context 'One credit' do
      def one_credit_csv
        %q[89, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 37.5,    0]
      end

      it 'One credit' do
        pending 'need to have payment without debit'
        property_create! human_ref: 89
        expect { ImportPayment.import parse one_credit_csv }.to \
          change(Credit, :count).by 1
      end
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end

    def credit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end
  end
end
