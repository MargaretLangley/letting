require 'spec_helper'

describe DueOns do

  let(:due_ons) { Charge.new.due_ons }

  context '#prepare' do
    it 'fills empty' do
      expect(due_ons).to have(0).items
      due_ons.prepare
      expect(due_ons).to have(4).items
    end
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

  context '#per_month' do
    it 'knows when the charge is not per month' do
      (1..12).each { due_ons.build day: 4, month: 1 }
      expect(due_ons.per_month.day).to eq 4
      expect(due_ons.per_month.month).to eq -1
    end
  end


  context 'creating, saving and loading' do

    it 'new on date' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.prepare
      charge.due_ons.build day: 24, month: 6
      charge.due_ons.build day: 25, month: 12
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      expect(reload.due_ons).to have(2).items
    end

    it 'on date to different on date' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.due_ons.build day: 24, month: 6, id: 7
      charge.due_ons.build day: 25, month: 12, id: 8
      charge.due_ons.prepare
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      reload.due_ons.prepare
      reload.due_ons[0].update day: 5, month: 1
      reload.due_ons[0].update day: '', month: ''
      reload.clean_up_form
      reload.save!
      reload2 = Charge.find(charge.id)
      expect(reload2.due_ons).to have(1).items
    end

    it 'new per date' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.due_ons.prepare
      charge.due_ons.build day: 5, month: -1
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      expect(reload.due_ons).to have(12).items
    end

    it 'per month to different per month' do
      charge_per_date = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge_per_date.prepare
      charge_per_date.due_ons.build day: 24, month: -1
      charge_per_date.clean_up_form
      charge_per_date.save!
      charge_diff_date = Charge.find(charge_per_date.id)
      charge_diff_date.prepare
      charge_diff_date.due_ons.build day: 10, month: -1
      charge_diff_date.clean_up_form
      charge_diff_date.save!
      charge_reload = Charge.find(charge_per_date.id)
      expect(charge_reload.due_ons).to have(12).items
    end

    it 'per month to same per month' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.prepare
      charge.due_ons.build day: 24, month: -1
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      reload.prepare
      reload.due_ons.build day: 24, month: -1
      reload.clean_up_form
      reload.save!
      reload2 = Charge.find(charge.id)
      reload2.prepare
      expect(reload2.due_ons).to have(12).items
    end

    it 'on date to per month' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.due_ons.build day: 24, month: 6
      charge.due_ons.build day: 25, month: 12
      charge.prepare
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      reload.prepare
      reload.due_ons.build day: 10, month: -1
      reload.clean_up_form
      reload.save!
      reload2 = Charge.find(charge.id)
      expect(reload2.due_ons).to have(12).items
    end

    it 'per month to on date' do
      charge = Charge.new charge_type: 'Rent', due_in: 'Advance', amount: '100.05', property_id: 1
      charge.prepare
      charge.due_ons.build day: 24, month: -1
      charge.clean_up_form
      charge.save!
      reload = Charge.find(charge.id)
      reload.prepare
      reload.due_ons.build day: 1, month: 5
      reload.due_ons.build day: 1, month: 11
      reload.clean_up_form
      reload.save!
      reload2 = Charge.find(charge.id)
      expect(reload2.due_ons).to have(2).items
    end

    it 'what happens if per_month day same as on date day' do
      pending
    end

    context 'due between' do
      before do
        due_ons.build day: 3, month: 5
      end

      it 'missing due on' do
        expect(due_ons.between? Date.new(2013, 4, 4) .. Date.new(2013, 5, 2) ).to be_false
      end

      it 'is between due on' do
        expect(due_ons.between? Date.new(2013, 4, 4) .. Date.new(2013, 5, 5)).to be_true
      end

    end

    it 'makes date between' do
      due_ons.build day: 3, month: 5
      expect(due_ons.make_date_between Date.new(2013, 4, 4) .. Date.new(2013, 5, 5) ).to eq Date.new 2013, 5, 3
    end

    it 'nils outside of date range' do
      due_ons.build day: 1, month: 2
      expect { due_ons.make_date_between Date.new(2013, 4, 4) .. Date.new(2013, 5, 5) }.to \
      raise_error NameError
    end

  end
end