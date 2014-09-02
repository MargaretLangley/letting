require 'rails_helper'

describe LiteralSearch, type: :model do

  describe '#go' do
    it 'return nil when no match' do
      expect(LiteralSearch.go '100').to eq nil
    end

    it 'return an exact property ref' do
      property = property_create human_ref: '100'
      expect(LiteralSearch.go '100').to eq property
    end

    it 'return an exact client ref' do
      client = client_create human_ref: '101'
      expect(LiteralSearch.go '101').to eq client
    end

    it 'return an exact user' do
      user = user_create nickname: 'george'
      expect(LiteralSearch.go 'george').to eq user
    end

    it 'return an exact charge cycle' do
      cycle = charge_cycle_create name: 'Mar/Sep'
      expect(LiteralSearch.go 'Mar/Sep').to eq cycle
    end
  end
end
