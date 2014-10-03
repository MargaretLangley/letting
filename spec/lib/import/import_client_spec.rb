require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_client'
# rubocop: disable Style/Documentation

module DB
  describe ImportClient, :import do

    def row
      %q(11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
      %q(Example Street, ,Example Town,  Example County,  E10 7EX)
    end

    def updated_row
      %q(11,  Mr,  E, Changed, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
      %q(Example Street, Example District,Example Town,  Example County,) +
      %q(E10 7EX)
    end

    it 'One row' do
      expect { import_client row }.to change(Client, :count).by 1
    end

    it 'Not double import' do
      import_client row
      expect { import_client row }.to_not change(Client, :count)
    end

    it 'updated changed entities' do
      import_client row
      import_client updated_row
      expect(Client.first.entities.full_name).to \
        eq 'Mr E. Changed & Mrs A. N. Other'
    end

    def import_client row, **args
      ImportClient.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
