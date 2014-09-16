require 'rails_helper'

describe DueOnsDecorator do
  let(:due_ons_dec) { DueOnsDecorator.new ChargeCycle.new.due_ons }

  # FIX_CHARGE
  # Not sure what we need at this stage

  context 'Charge prepare' do

    let(:prepared_due_ons) do
      charge = ChargeCycle.new
      charge.prepare
      due_ons_dec = DueOnsDecorator.new charge.due_ons
      due_ons_dec
    end

    it '#id' do
      expect(prepared_due_ons.id 3).to eq 'property_charge_3'
    end

    it '#by_date' do
      expect(prepared_due_ons.by_date.size).to eq 4
    end
  end
end
