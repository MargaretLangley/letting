require 'rails_helper'

describe 'DueOn Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(due_on_new day: 1, month: 1).to be_valid }
      it('is not persisted') { expect(due_on_new day: 1, month: 1).to be_valid }
    end

    describe 'overrides' do
      it 'overrides show month' do
        expect((due_on_new show_month: 5, show_day: 6).show_month)
          .to eq 5
      end

      it 'overrides show day' do
        expect((due_on_new show_month: 5, show_day: 6).show_day)
          .to eq 6
      end
    end
  end

  describe 'created' do
    it 'is created' do
      expect(due_on_create day: 1, month: 1).to be_persisted
    end
  end
end
