require 'spec_helper'

describe PropertiesHelper, type: :helper do
  describe '#hide_new_record_unless_first' do
    it 'display if new and first' do
      property = property_new
      property.prepare_for_form
      charge = property.account.charges.first
      expect(hide_new_record_unless_first(charge, 0)).to be_blank
    end

    it 'hide if new and not first' do
      property = property_new
      property.prepare_for_form
      charge = property.account.charges.first
      expect(hide_new_record_unless_first(charge, 1)).to eq 'js-revealable'
    end

    it 'displays if valid' do
      charge = property_with_charge_new.account.charges.first
      expect(hide_new_record_unless_first(charge, 0)).to be_blank
    end
  end
end
