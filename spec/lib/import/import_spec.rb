require_relative '../../../lib/import/file_import'

module DB
  describe FileImport do

    context 'to_a' do
      it 'errors if file unknown' do
        expect { FileImport.to_a 'client' }.to raise_error Errno::ENOENT
      end

      it 'opens valid file' do
        output = FileImport.to_a('open_test',
                                 location: file_location)
        expect(output.length).to eq 1
      end
    end

    context 'arguments' do
      it 'can set file location' do
        expect(FileImport.new(file_location, 0, true).location).to \
          eq 'spec/fixtures/import_data'
      end

      it 'can drop rows' do
        output = FileImport.to_a('open_test',
                                 location: file_location,
                                 drop_rows: 1)
        expect(output.length).to eq 1
      end

      it 'headers can be overriden' do
        output = FileImport.to_a('open_test',
                                 header: %w{one line},
                                 location: file_location)
        output.each do |row|
          expect(row[:one]).to_not be_nil
          expect(row[:line]).to_not be_nil
        end
      end

    end

    def file_location
      'spec/fixtures/import_data'
    end
  end
end
