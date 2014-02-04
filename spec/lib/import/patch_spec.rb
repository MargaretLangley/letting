require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/patch'
require_relative '../../../lib/import/import_client'
require_relative '../../../lib/import/import_property'
require_relative '../../../lib/import/import_billing_profile'

module DB
  describe 'Patch', :import do

    context 'Client' do

      def row
        %q[11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ] +
        %q[Example Street, ,Example Town,  Example County,  E10 7EX]
      end

      def different_id
        %q[12,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ] +
        %q[Example Street, Example District ,Example Town,  Example County,  E10 7EX]
      end

      def same_id
        %q[11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ] +
        %q[Example Street, Example District ,Example Town,  Example County,  E10 7EX]
      end

      def same_id_name_changed
        %q[11,  Mr,  A, Name Changed, Mrs, A N, Other, 1, ExampleHouse,  2, ] +
        %q[Example Street, Example District ,Example Town,  Example County,  E10 7EX]
      end


      it 'only patches when id are the same' do
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(different_id))
        expect(Client.first.address.district).to be_blank
      end

      it 'if import row id == patch row id - change attributes' do
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(same_id))
        expect(Client.first.address.district).to eq 'Example District'
      end

      it 'if id match but entity names are differenit it errors' do
        $stdout.should_receive(:puts).with(/Cannot match/)
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(same_id_name_changed))

      end
    end

    context 'Property' do

      def row
        %q[122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,] +
        %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ] +
        %q[11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0]
      end

      def patch_row
        %q[122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,] +
        %q[1, ExampleHouse, 2, Ex Street, Example District ,Ex Town, Ex County, E10 7EX, ] +
        %q[11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0]
      end


      it 'works on property' do
        client_create! human_ref: 11
        ImportProperty.import parse_property(row),
                              patch: Patch.import(Property, parse_property(patch_row))
        expect(Property.first.address.district).to eq 'Example District'
      end
    end

    context 'BillingProfile' do
      it 'works on BillingProfile' do
        property_create! human_ref: 122
        ImportBillingProfile.import \
          billing_csv, patch: Patch
          .import(BillingProfileWithId, billing_patch_csv)
        expect(Property.first.billing_profile.address.district)
          .to eq 'Example District Changed'
      end
    end

    def parse_client row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end

    def parse_property row_string
      CSV.parse(row_string,
                headers: FileHeader.property,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end

    def billing_csv
      FileImport.to_a('address2',
                      headers: FileHeader.billing_profile,
                      location: billing_profile_dir)
    end

    def billing_profile_dir
      'spec/fixtures/import_data/billing_profiles'
    end

    def billing_patch_csv
      FileImport.to_a('address2_patch',
                      headers: FileHeader.billing_profile,
                      location: 'spec/fixtures/import_data/patch')
    end
  end
end
