require_relative '../../../lib/stage/stage'
require_relative '../../../lib/stage/patch_ref'
require_relative '../../../lib/stage/extract_ref'
require_relative '../../../lib/csv/csv_transform'
# rubocop: disable Metrics/LineLength

describe Stage, :stage do
  describe 'initialize' do
    describe 'headers' do
      it 'can be set directly' do
        stage = Stage.new file_name: 'blah.csv',
                          input: [{ human_ref: 1, other: 'world' }],
                          instructions: [{ human_ref: 2, other: 'word' }],
                          headers: ['hello']

        expect(stage.headers).to eq ['hello']
      end

      it 'can be set through input' do
        stage = \
          Stage.new \
            file_name: 'blah.csv',
            input: DB::CSVTransform.new(file_name: 'import_data/legacy/clients.csv',
                                        headers: ['hello']),
            instructions: [{ human_ref: 2, other: 'word' }]

        expect(stage.headers).to eq ['hello']
      end
    end
  end

  it 'completes full test one instruction' do
    client = Stage.new file_name: 'blah.csv',
                       input: [{ human_ref: 1, other: 'world' }],
                       instructions: [PatchRef.new(patch: [{ human_ref: 1, other: 'word' }])],
                       headers: ['hello']
    expect(client).to receive(:stage_array)
                        .with rows: [{ human_ref: 1, other: 'word' }]
    client.stage
  end

  it 'completes full test multiple instruction' do
    client = Stage.new file_name: 'blah.csv',
                       input: [{ human_ref: 1, other: 'world' },
                               { human_ref: 2, other: 'world' }],
                       instructions: [PatchRef.new(patch: [{ human_ref: 1, other: 'word' }]),
                                      ExtractRef.new(extracts: [{ human_ref: 2 }])],
                       headers: ['hello']
    expect(client).to receive(:stage_array)
                        .with rows: [{ human_ref: 1, other: 'word' }]
    client.stage
  end
end
