require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_billing_profile'

module DB
  describe ImportBillingProfile, :import do
    let!(:property) do
      property_create! human_ref: 122
    end

    def row
      %q[122, Mr, B P, Example, Mrs, A N, Other,] +
      %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ]
    end

    it 'One row' do
      expect(BillingProfile.first.use_profile).to be_false
      expect { import_billing row }.to_not change(BillingProfile, :count)
      expect(BillingProfile.first.use_profile).to be_true
    end

    # contact entites test suite in import_contact_entity_spec
    #
    it 'Property has two entities' do
      import_billing row
      expect(BillingProfile.first.entities.full_name).to \
          eq 'Mr B. P. Example & Mrs A. N. Other'
    end

    context 'filter' do
      it 'allows within range' do
        import_billing row, range: 122..122
        expect(BillingProfile.first.use_profile).to be_true
      end

      it 'filters if out of range' do
        import_billing row, range: 120..121
        expect(BillingProfile.first.use_profile).to be_false
      end
    end

    def import_billing row, args = {}
      ImportBillingProfile.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.billing_profile,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end
  end
end
