require 'rails_helper'

RSpec.describe ChargedIn, :ledgers, type: :model do
  describe 'validations' do
    it 'is valid' do
      expect(ChargedIn.new name: 'Advance').to be_valid
    end

    it 'requires a name' do
      expect(ChargedIn.new name: '').to_not be_valid
    end

    it 'includes name of advance' do
      expect(ChargedIn.new name: 'Advance').to be_valid
    end

    it 'includes name of arrears' do
      expect(ChargedIn.new name: 'Arrears').to be_valid
    end

    it 'includes name of arrears' do
      expect(ChargedIn.new name: 'Mid-Term').to be_valid
    end

    it 'no other name accepted' do
      expect(ChargedIn.new name: 'Anything').to_not be_valid
    end
  end
end
