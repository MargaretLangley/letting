require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#format_empty_string_as_dash' do
    it 'adds a dash when string empty' do
      expect(format_empty_string_as_dash('')).to eq '-'
    end

    it 'outputs a present string unchanged' do
      expect(format_empty_string_as_dash('Test')).to eq 'Test'
    end
  end

  describe '#salient_date_range' do
    it 'includes salient_date interface' do
      expect(salient_date_range start_date: Date.new(Time.zone.now.year, 4, 5),
                                end_date: Date.new(Time.zone.now.year, 6, 7))
        .to eq '05/Apr - 07/Jun'
    end
  end

  describe '#safe_date' do
    it 'it includes safe_date interface' do
      expect(safe_date date: nil, format: :short).to eq ''
    end
  end
end
