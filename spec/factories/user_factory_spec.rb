require 'rails_helper'

describe 'UserFactory' do
  describe 'create' do
    it('is valid') do
      expect(user_create).to be_valid
    end
    it('has nickname') { expect(user_create.nickname).to eq 'user' }

    describe 'override' do
      it 'changes nickname' do
        expect(user_create(nickname: 'zed').nickname).to eq 'zed'
      end
    end
  end
end
