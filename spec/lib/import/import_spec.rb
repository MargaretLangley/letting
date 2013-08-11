require_relative '../../../lib/import/import'

namespace :db do
  describe Import do

    context 'location' do
      it 'can be set during initialization' do
        expect(Import.new('spec/import_data').location).to eq 'spec/import_data'
      end
    end

    context 'csv_table' do
      it 'Expected error if file unknown' do
        expect { Import.csv_table 'client' }.to raise_error Errno::ENOENT
      end

      it 'Opens file a valid file' do
        output = Import.csv_table('open_test', 'spec/import_data')
        expect(output.length).to eq 1
      end
    end

  end
end