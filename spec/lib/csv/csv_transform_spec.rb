require_relative '../../../lib/csv/csv_transform'
# rubocop: disable Style/Documentation

module DB
  describe CSVTransform, :import do

    context 'to_a' do
      it 'errors if file unknown' do
        expect { CSVTransform.to_a 'client' }.to raise_error Errno::ENOENT
      end

      it 'opens valid file' do
        output = CSVTransform.to_a('open_test',
                                   location: file_location)
        expect(output.length).to eq 1
      end
    end

    context 'arguments' do
      it 'sets the file location' do
        expect(CSVTransform.new(file_location, 0, true).location)
          .to eq 'spec/fixtures/import_data'
      end

      it 'drops rows' do
        output = CSVTransform.to_a('open_test',
                                   location: file_location,
                                   drop_rows: 1)
        expect(output.length).to eq 1
      end

      it 'overwrites headers' do
        output = CSVTransform.to_a('open_test',
                                   headers: %w(one line),
                                   location: file_location)
        output.each do |row|
          expect(row[:one]).to be_present
          expect(row[:line]).to be_present
        end
      end

    end

    def file_location
      'spec/fixtures/import_data'
    end
  end
end
