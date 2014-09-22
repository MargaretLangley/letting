require 'rails_helper'

describe 'Product Factory' do
  describe 'default' do
    it('is valid') { expect(product_new).to be_valid }
    it('has charge') { expect(product_new.charge_type).to eq 'Rent' }
    it 'has date_due' do
     expect(product_new.date_due.to_s).to eq '2014-06-07'
    end
    it 'has range' do
     expect(product_new.range).to eq '30/9/2010 to 25/3/20011'
    end
  end
end

