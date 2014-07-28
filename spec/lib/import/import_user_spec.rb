require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_user'
# rubocop: disable Style/Documentation

module DB
  describe ImportUser, :import do

    def row
      %q("Rich", richard.wigley@gmail.com,  password,  TRUE)
    end

    it 'One row' do
      expect { ImportUser.import parse(row) }
        .to change(User, :count).by 1
    end

    it 'Not double import' do
      ImportUser.import parse(row)
      expect { ImportUser.import parse(row) }.to_not change(User, :count)
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.user,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
