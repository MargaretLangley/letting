require 'spec_helper'

describe DueOnsDecorator do
  let(:due_ons_dec) { DueOnsDecorator.new Charge.new.due_ons }

  context 'Charge prepare' do

    let(:prepared_due_ons) do
      charge = Charge.new
      charge.prepare
      due_ons_dec = DueOnsDecorator.new charge.due_ons
      due_ons_dec
    end

    it '#by_date' do
      expect(prepared_due_ons.by_date.size).to eq 4
    end

    context '#per_month' do
      it 'returns one' do
        due_ons = Charge.new.due_ons
        (1..12).each.with_index { |index| due_ons.build day: 3, month: index }
        due_on_dec = DueOnsDecorator.new due_ons
        expect(due_on_dec.per_month.day).to eq 3
        expect(due_on_dec.per_month.month).to eq(-1)
      end
    end
  end

  context '#hidden_side?' do
    context 'on date' do
      it 'hides on date' do
        expect(due_ons_dec.hidden_side? DueOn::ON_DATE).to eq ''
      end
      it 'visible' do
        expect(due_ons_dec.hidden_side? DueOn::PER_MONTH).to eq 'hidden'
      end
    end
    context 'monthly' do
      it 'hides on date' do
        due_ons_dec.build day: 1, month: DueOn::PER_MONTH
        expect(due_ons_dec.hidden_side? DueOn::ON_DATE).to eq 'hidden'
      end
      it 'visible' do
        due_ons_dec.build day: 1, month: DueOn::PER_MONTH
        expect(due_ons_dec.hidden_side? DueOn::PER_MONTH).to eq ''
      end
    end

  end
end
