require 'rails_helper'

describe 'ChargeStructure Factory' do
  it 'is valid' do
    expect(charge_structure_new).to be_valid
  end

  it 'is creates' do
    expect { charge_structure_create }.to change(ChargeStructure, :count).by(1)
  end

  describe 'has due_on' do
    it 'day' do
      expect(charge_structure_new.due_ons[0].day).to eq 25
    end

    it 'month' do
      expect(charge_structure_new.due_ons[0].month).to eq 3
    end
  end

  # describe 'overrides' do
  #   it('due on') do
  #     account = charge_structure_new due_on_attribute: { month: 6 }
  #     expect(charge_structure_new.due_ons[0].month).to eq 6
  #   end
  # end
end
