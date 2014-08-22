require 'rails_helper'

RSpec.describe ChargeDecorator do
  describe 'style' do
    it 'can be emphasized' do
      charge = ChargeDecorator.new charge_new
      expect(charge.style_emphasis).to eq ''
    end

    it 'can be demphasized' do
      charge = ChargeDecorator.new charge_new dormant: true
      expect(charge.style_emphasis).to eq 'dormant'
    end
  end
  describe 'dormancy state' do
    it 'returns true' do
      charge = ChargeDecorator.new charge_new
      expect(charge.dormant).to eq 'No'
    end
    it 'returns false' do
      charge = ChargeDecorator.new charge_new dormant: true
      expect(charge.dormant).to eq 'Yes'
    end
  end
end
