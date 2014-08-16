require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_payment'
# rubocop: disable Style/Documentation

module DB
  describe ImportPayment, :import do

    it 'single credit' do
      charge_structure_create
      property = property_create human_ref: 89
      charge_new(account_id: property.account.id).save!

      expect { ImportPayment.import parse credit_row }.to \
        change(Credit, :count).by 1
    end

    context 'errors' do
      it 'double import raises error' do
        skip 'will not work until model_prepared can find_model'
        property = property_create human_ref: 89
        charge_new(account_id: property.account.id).save!

        ImportPayment.import parse credit_row
        expect { ImportPayment.import parse credit_row }.to \
          raise_error NotIdempotent
      end
    end

    def credit_row
      %q(89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0)
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
