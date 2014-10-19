require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe 'initializes' do
  it 'can use repeat dates' do
    skip 'in progress'
    repeat = FixedTerm.new repeat_dates: [RepeatDate.new(month: 5, day: 4)]
    expect(repeat.periods.length).to eq 1
  end
end
