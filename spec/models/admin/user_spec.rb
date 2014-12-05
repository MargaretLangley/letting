require 'rails_helper'

describe User, type: :model do
  let(:user) { User.new user_attributes }

  describe 'validations' do
    it('is valid') { expect(user).to be_valid }

    describe '#email' do
      it 'present' do
        user.email = nil
        expect(user).to_not be_valid
      end

      it 'is unique' do
        User.create! user_attributes email: 'user@example.com'
        expect { User.create! user_attributes email: 'user@example.com' }
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'requires @' do
        user.email = 'noat'
        expect(user).to_not be_valid
      end
    end

    describe 'password' do
      it 'is present' do
        # Bug you can't assign a nil password you can initialize it with
        # empty string
        # stackoverflow.com why-is-password-validate-presence-ignored
        user = User.new password: ''
        expect(user).to_not be_valid
      end

      it 'must equal confirmation' do
        user.password = 'something'
        user.password_confirmation = 'orother'
        expect(user).to_not be_valid
      end

      it 'errors with blank confirmation' do
        user.password = 'something'
        user.password_confirmation = ''
        expect(user).to_not be_valid
      end
    end
  end
end
