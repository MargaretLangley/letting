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
        charge.amount = 100_000
        expect(charge).to_not be_valid
      end
    end
  end

  context 'Assocations' do
    it('belongs to an account') { expect(charge).to respond_to(:account) }
    it('is DueOns') { expect(charge).to respond_to(:due_ons) }
  end

  context 'methods' do

    context 'charging' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after  { Timecop.return }

      context '#due_between?' do
        context 'in charge_range' do
          it 'true' do
            expect(charge.due_between? date_when_charged).to be_true
          end

          it 'false' do
            expect(charge.due_between? dates_not_charged_on).to be_false
          end
        end
        context 'out of charge_range' do
          it 'is is false' do
            charge.end_date = '2002-1-1'
            expect(charge.due_between? date_when_charged).to be_false
          end
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

    it '#prepare creates children' do
      charge.prepare
      expect(charge.due_ons).to have(4).items
    end

    it '#clear_up_form destroys children' do
      charge.clear_up_form
      expect(charge.due_ons).to have(1).items
    end

    context '#edited?' do

      it 'true when user has set a value on charge or children' do
        expect(charge).to be_edited
      end

      it 'false when the user has not set a value on charge or children' do
        charge.attributes = { charge_type: '', due_in: '', amount: '',
                              start_date: MIN_DATE }
        charge.due_ons[0].attributes = { day: nil, month: nil }
        expect(charge).to_not be_edited
      end

    end

    context '#active?' do
      it 'in date range active' do
        Timecop.travel(Date.new(2013, 3, 25))
        expect(charge).to be_active
        Timecop.return
      end
      it 'out of date range inactive' do
        Timecop.travel(Date.new(2011, 3, 24))
        expect(charge).to_not be_active
        Timecop.return
      end
    end
  end
end
