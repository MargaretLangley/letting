require_relative '../../../lib/stage/extraction_acc_items'

describe ExtractionAccItems, :stage do
  def row human_ref: 10,
          charge_type: 'Rent',
          on_date: Date.new(2014, 3, 8),
          value: 4
    { human_ref: human_ref,
      charge_type: charge_type,
      on_date: on_date,
      value: value }
  end

  it 'does not delete when different' do
    input = [row(human_ref: 10,
                 charge_type: 'Rent',
                 on_date: Date.new(2014, 3, 8),
                 value: 4)]
    patch = ExtractionAccItems.new \
              extracts: [row(human_ref: 20,
                             charge_type: 'Rent',
                             on_date: Date.new(2014, 3, 8),
                             value: 8)]
    patch.cleanse originals: input
    expect(input).to eq [row(human_ref: 10,
                             charge_type: 'Rent',
                             on_date: Date.new(2014, 3, 8),
                             value: 4)]
  end

  it 'deletes when id match' do
    input = [row(human_ref: 10,
                 charge_type: 'Rent',
                 on_date: Date.new(2014, 3, 8),
                 value: 4)]
    patch = ExtractionAccItems.new \
              extracts: [row(human_ref: 10,
                             charge_type: 'Rent',
                             on_date: Date.new(2014, 3, 8),
                             value: 8)]
    patch.cleanse originals: input
    expect(input).to eq []
  end
end
