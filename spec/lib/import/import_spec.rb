require_relative '../../../lib/import/import'

module DB
  describe Import do

    context 'csv_table' do
      it 'Expected error if file unknown' do
        expect { Import.csv_table 'client' }.to raise_error Errno::ENOENT
      end

      it 'Opens file a valid file' do
        output = Import.csv_table('open_test', location: 'spec/fixtures/import_data')
        expect(output.length).to eq 1
      end
    end

    context 'arguments' do
      context ':location' do
        it 'can be set during initialization' do
          expect(Import.new('spec/fixtures/import_data', 0, true).location).to eq 'spec/fixtures/import_data'
        end
      end


      context ':drop_rows' do
        it 'can drop a row' do
          output = Import.csv_table('open_test', location: 'spec/fixtures/import_data', drop_rows: 1)
          expect(output.length).to eq 1
        end
      end

      context ':headers' do
        it 'overrides headers if required' do
          output = Import.csv_table('open_test', header: %{one line}, location: 'spec/fixtures/import_data')
          output.each do |row|
            expect(row[:one]).to_not be_nil
            expect(row[:line]).to_not be_nil
          end
        end
      end
    end
  end
end