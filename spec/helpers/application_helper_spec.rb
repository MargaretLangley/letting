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
  describe '#view_link' do
    it 'disables new records' do
      expect(view_link(property_new)).to include 'disabled'
    end

    it 'enables persisted records' do
      expect(view_link(property_create)).to_not include 'disabled'
    end
  end

  describe '#noticable_date_range' do
    it 'outputs date without year when same year' do
      expect(noticable_date_range start_date: Date.parse('2014-04-05'),
                                  end_date: Date.parse('2014-06-07'))
        .to eq '05/Apr - 07/Jun'
    end

    it 'outputs date with year when different year' do
      expect(noticable_date_range start_date: Date.parse('2014-04-05'),
                                  end_date: Date.parse('2015-06-07'))
        .to eq '05/Apr/14 - 07/Jun/15'
    end

    it 'handles nil start date' do
      expect(noticable_date_range start_date: nil,
                                  end_date: Date.parse('2014-06-07'))
        .to eq ' - 07/Jun/14'
    end

    it 'handles nil end date' do
      expect(noticable_date_range start_date: Date.parse('2014-06-07'),
                                  end_date: nil)
        .to eq '07/Jun/14 - '
    end
  end

  describe '#safe_date' do
    it 'handles nil date' do
      expect(safe_date date: nil, format: :short).to eq ''
    end

    it 'outputs a present string unchanged' do
      expect(safe_date date: Date.parse('2014-06-07'), format: :short)
        .to eq '07/Jun/14'
    end
  end
end
