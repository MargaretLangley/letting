require 'spec_helper'

describe Charge do
  let(:charge) do
    charge = Charge.new charge_attributes id: 1
    charge.due_ons.new due_on_attributes_0 charge_id: 1
    charge
  end

  it('is valid') { expect(charge).to be_valid }

  context 'validations' do
    context 'presence' do

      it 'charge type' do
        charge.charge_type = nil
        expect(charge).to_not be_valid
      end

      it 'due in' do
        charge.due_in = nil
        expect(charge).to_not be_valid
      end

      it 'amount' do
        charge.amount = nil
        expect(charge).to_not be_valid
      end

      it 'due_ons' do
        charge.due_ons.destroy_all
        expect(charge).to_not be_valid
      end

      context 'due_ons_size' do
        it 'not valid one over limit' do
          (1..12).each { charge.due_ons.build day: 25, month: 3 }
          expect(charge).to_not be_valid
        end
        it 'valid if marked for destruction' do
          (1..12).each { charge.due_ons.build day: 25, month: 3 }
          charge.due_ons.first.mark_for_destruction
          expect(charge).to be_valid
        end
      end
    end
    context 'amount' do
      it 'is a number' do
        charge.amount = 'nnn'
        expect(charge).to_not be_valid
      end
      it 'has a maximum' do
        charge.amount = 100000
        expect(charge).to_not be_valid
      end
    end
  end

  context 'Assocations' do
    it('belongs to an account') { expect(charge).to respond_to(:account) }
    it('is DueOns') { expect(charge).to respond_to(:due_ons) }
  end

  context 'methods' do

    it '#prepare creates children' do
      charge.prepare
      expect(charge.due_ons).to have(4).items
    end

    it '#clean_up_form destroys children' do
      charge.clean_up_form
      expect(charge.due_ons).to have(1).items
    end

    context '#empty?' do
      it 'valid is not empty' do
        expect(charge).to be_present
      end

      it 'charge is not empty if due_ons not empty' do
        charge.attributes = { charge_type: '', due_in: '', amount: '' }
        expect(charge).to be_present
      end

      it 'if charge and due_ons attributes empty' do
        charge.attributes = { charge_type: '', due_in: '', amount: '' }
        charge.due_ons[0].attributes = { day: nil, month: nil }
        expect(charge).to be_empty
      end
    end

    context 'charging' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after  { Timecop.return }

      context '#due_between?' do
        it 'true' do
          expect(charge.due_between? date_when_charged).to be_true
        end

        it 'false' do
          expect(charge.due_between? dates_not_charged_on).to be_false
        end
      end

      context '#chargeable_info' do
        it 'if charge between dates'  do
          expect(charge.chargeable_info date_when_charged).to eq \
            ChargeableInfo.from_charge chargeable_attributes
        end
      end
      def date_when_charged
        Date.new(2013, 3, 25) .. Date.new(2013, 3, 25)
      end

      def dates_not_charged_on
        Date.new(2013, 2, 1) .. Date.new(2013, 3, 24)
      end
    end
  end
end
