require 'spec_helper'

describe StringDate, type: :model do
  context 'method' do
    context 'to_date' do
      it 'for date' do
        expect(StringDate.new('2000-1-1').to_date).to eq Date.new 2000,1,1
      end

      it 'handles emtpy' do
        expect(StringDate.new('').to_date).to be_nil
      end

      it 'handles malformed date' do
        expect(StringDate.new('2012-x').to_date).to be_nil
      end
    end

    context 'valid?' do
      it 'normal valid' do
        expect(StringDate.new('2012-1-1')).to be_valid
      end

      it 'malformed invalid' do
        expect(StringDate.new('2012-x')).to_not be_valid
      end
    end
  end

end
