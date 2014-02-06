require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/contact_row'

module DB
  describe ContactRow do

    def contact_row
      %q[11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ] +
      %q[Example Street, District ,Example Town,  Example County,  E10 7EX, SPAIN]
    end

    def lower_case_town_row
      %q[11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ] +
      %q[Example Street, District ,example town,  Example County,  E10 7EX, SPAIN]
    end

    context 'entity' do
      it 'title' do
        row = ContactRow.new parse_line contact_row
        expect(row.entities.length).to eq 2
      end
    end

    context 'address' do
      it 'structure returned' do
        row = ContactRow.new parse_line contact_row
        expect(row.address_attributes[:flat_no]).to eq '1'
        expect(row.address_attributes[:house_name]).to eq 'ExampleHouse'
        expect(row.address_attributes[:road_no]).to eq '2'
        expect(row.address_attributes[:road]).to eq 'Example Street'
        expect(row.address_attributes[:district]).to eq 'District'
        expect(row.address_attributes[:town]).to eq 'Example Town'
        expect(row.address_attributes[:county]).to eq 'Example County'
        expect(row.address_attributes[:postcode]).to eq 'E10 7EX'
        expect(row.address_attributes[:nation]).to eq 'SPAIN'
      end
    end

    context 'address' do
      it 'structure returned' do
        row = ContactRow.new parse_line lower_case_town_row
        expect(row.address_attributes[:town]).to eq 'Example Town'
      end
    end



    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.agent_patch,
                     header_converters: :symbol,
                     converters: -> (f) { f ? f.strip : nil }
                    )
    end
  end
end
