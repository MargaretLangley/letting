require 'spec_helper'

describe SearchDate, :type => :model do
  context 'valid' do
    it 'for date' do
      expect(SearchDate.new('2000-1-1')).to be_valid_date
    end

    it 'handles emtpy' do
      expect(SearchDate.new('')).to_not be_valid_date
    end

    it 'handles malformed date' do
      expect(SearchDate.new('2012-x')).to_not be_valid_date
    end
  end
end
