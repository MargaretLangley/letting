require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_payment'

module DB
  describe ImportPayment do

    it 'imports basic' do
      property_create! human_ref: 89
      expect { ImportPayment.import [ parse_line(credit_row) ] }.to \
        change(Payment, :count).by 1
    end

    it 'imports with debit' do
      (property_with_unpaid_debit human_ref: 89).save!
      expect { ImportPayment.import [ parse_line(credit_row) ] }.to \
        change(Credit, :count).by 1
    end


    def parse_line row_string
      CSV.parse_line( row_string,
                      { headers: FileHeader.account,
                        header_converters: :symbol,
                        converters: lambda { |f| f ? f.strip : nil } }
                    )
    end

    def credit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end

  end
end