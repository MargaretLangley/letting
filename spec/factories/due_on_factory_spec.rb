require 'rails_helper'

describe 'DueOn Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(due_on_new day: 1, month: 1).to be_valid }
      it('is not persisted') { expect(due_on_new day: 1, month: 1).to be_valid }
    end
  end

  describe 'created' do
    it 'is created' do
      expect(due_on_create day: 1, month: 1).to be_persisted
    end
  end
end
