require 'rails_helper'

describe RevealHelper, type: :helper do
  describe '#hide_extra_new_records' do
    it 'display if new and first' do
      object = double
      allow(object).to receive('new_record?').and_return true
      expect(hide_extra_new_records record: object, index: 0 )
        .to be_blank
    end

    it 'hide if new and not first' do
      object = double
      allow(object).to receive('new_record?').and_return true
      expect(hide_extra_new_records(record: object, index: 1)).to eq 'js-revealable'
    end

    it 'displays if valid' do
      object = double
      allow(object).to receive('new_record?').and_return false
      expect(hide_extra_new_records(record: object, index: 0)).to be_blank
    end
  end

  describe 'hide_or_destroy' do
    it 'return true if first' do
      object = double
      allow(object).to receive('new_record?').and_return true
      expect(hide_or_destroy record: object).to eq 'js-hide-link'
    end

    it 'return false otherwise' do
      object = double
      allow(object).to receive('new_record?').and_return false
      expect(hide_or_destroy record: object).to eq 'js-destroy-link'
    end
  end

  describe 'first_records' do
    it 'return true if first' do
      expect(first_record? index: 0).to eq true
    end
    it 'return false otherwise' do
      expect(first_record? index: 1).to eq false
    end
  end
end
