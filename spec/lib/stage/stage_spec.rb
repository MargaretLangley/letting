require_relative '../../../lib/stage/stage'
require_relative '../../../lib/csv/csv_transform'
# rubocop: disable Metrics/LineLength

describe Stage, :stage do
  describe 'initialize' do
    describe 'headers' do
      it 'can be set directly' do
        stage = Stage.new file_name: 'blah.csv',
                          input: [{ human_ref: 1, other: 'world' }],
                          patch: [{ human_ref: 2, other: 'word' }],
                          headers: ['hello']

        expect(stage.headers).to eq ['hello']
      end

      it 'can be set through input' do
        stage = \
          Stage.new \
            file_name: 'blah.csv',
            input: DB::CSVTransform.new(file_name: 'import_data/legacy/clients.csv',
                                        headers: ['hello']),
            patch: [{ human_ref: 2, other: 'word' }]

        expect(stage.headers).to eq ['hello']
      end
    end
  end

  it 'completes full test' do
    client = Stage.new file_name: 'blah.csv',
                       input: [{ human_ref: 1, other: 'world' }],
                       patch: PatchClient.new(patch: [{ human_ref: 1, other: 'word' }]),
                       headers: ['hello']
    expect(client).to receive(:stage_array)
                        .with rows: [{ human_ref: 1, other: 'word' }]
    client.stage
  end
end
