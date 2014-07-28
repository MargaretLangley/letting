require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/contact_row'
# rubocop: disable Style/Documentation

module DB
  describe ContactRow do

    def contact_row
      %q(11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ) +
      %q(Example Street, District ,Example Town,  Example County,) +
      %q(E10 7EX, SPAIN)
    end

    context 'entity' do
      it 'title' do
        row = ContactRow.new parse_line contact_row
        expect(row.entities.length).to eq 2
      end
    end

    describe '#update_for' do
      it 'updates address from row' do
        client = client_new
        ContactRow.new(parse_line contact_row).update_for client

        expect(client.address.flat_no).to eq '1'
        expect(client.address.house_name).to eq 'ExampleHouse'
        expect(client.address.road_no).to eq '2'
        expect(client.address.road).to eq 'Example Street'
        expect(client.address.district).to eq 'District'
        expect(client.address.town).to eq 'Example Town'
        expect(client.address.county).to eq 'Example County'
        expect(client.address.postcode).to eq 'E10 7EX'
        expect(client.address.nation).to eq 'SPAIN'
      end

      it 'titleizes town names' do

        lower_case_town_row = \
        %q(11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ) +
        %q(Example Street, District ,example town,  Example County,  ) +
        %q(E10 7EX, SPAIN)

        client = client_new address_attributes: { town: 'this town is changed' }
        ContactRow.new(parse_line lower_case_town_row).update_for client
        expect(client.address.town).to eq 'Example Town'
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.agent_patch,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end
  end
end
