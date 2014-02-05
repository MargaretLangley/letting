require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/contact_row'

module DB
  describe ContactRow do

    def client_row
      %q[11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ] +
      %q[Example Street, ,Example Town,  Example County,  E10 7EX]
    end

    let(:row) { ContactRow.new parse_line client_row }

    context 'entity' do
      it 'title' do
        expect(row.entities.length).to eq 2
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.client,
                     header_converters: :symbol,
                     converters: -> (f) { f ? f.strip : nil }
                    )
    end
  end
end
