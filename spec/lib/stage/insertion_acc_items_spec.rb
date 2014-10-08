require_relative '../../../lib/stage/insertion_acc_items'

describe InsertionAccItems, :stage do
  def row human_ref: 10,
          charge_type: 'Rent',
          on_date: Date.new(2014, 3, 8),
          value: 4
    { human_ref: human_ref,
      charge_type: charge_type,
      on_date: on_date,
      value: value }
  end

  it 'inserts' do
    input = [row(human_ref: 5,
                 charge_type: 'Rent',
                 on_date: Date.new(2014, 3, 8))]
    insert = InsertionAccItems.new \
              insert: [row(human_ref: 10,
                           charge_type: 'Rent',
                           on_date: Date.new(2014, 3, 9))]
    expect(insert.cleanse originals: input)
      .to eq [row(human_ref: 5,
                  charge_type: 'Rent',
                  on_date: Date.new(2014, 3, 8),
                  value: 4),
              row(human_ref: 10,
                  charge_type: 'Rent',
                  on_date: Date.new(2014, 3, 9),
                  value: 4)]
  end
end
