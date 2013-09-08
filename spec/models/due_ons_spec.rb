require 'spec_helper'

describe DueOns do

  let(:due_ons) { property_factory.charges.build.due_ons }

  it '#prepare' do
    expect(due_ons).to have(0).items
    due_ons.prepare
    expect(due_ons).to have(12).items
  end

  context '#empty?' do
    it 'is empty when nothing in it' do
      expect(due_ons).to be_empty
    end

    it 'not empty when something in it' do
      due_ons.build due_on_attributes_0
      expect(due_ons).to_not be_empty
    end
  end

  context '#cleans up form' do
    it 'leaves valid or partially filled due_ons' do
      due_on = due_ons.build due_on_attributes_0
      due_ons.build
      due_ons.clean_up_form
      expect(due_ons.reject(&:empty?)).to have(1).items
    end

    it 'cleans up entirely if empty' do
      due_ons.build
      due_ons.build
      due_ons.clean_up_form
      expect(due_ons.reject(&:empty?)).to have(0).items
    end
  end

  context '#per month?' do
    context 'by number' do
      it 'knows when the charge is not per month' do
        due_ons.build day: 1, month: 1, charge_id: 1
        expect(due_ons).to_not be_per_month
      end
      it 'knows when the charge is not per month' do
        (1..12).each { due_ons.build day: 1, month: 1 }
        expect(due_ons).to be_per_month
      end

      it 'max displayed dueons does not make it per month' do
        (1..4).each { due_ons.build day: 1, month: 1 }
        (5..12).each { due_ons.build }
        expect(due_ons).not_to be_per_month
      end
    end
    context 'by per_month due_on' do
      it 'is not per month without it' do
        due_ons.build day: 1, month: -1
        expect(due_ons).to be_per_month
      end
    end
  end



end