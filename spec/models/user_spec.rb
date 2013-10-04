require 'spec_helper'

describe User do
  let(:user) { User.new user_attributes }
  it('is valid') { expect(user).to be_valid }

  context 'validations' do
    context '#email' do

      it 'present' do
        user.email = nil
        expect(user).not_to be_valid
      end

      it('unique') do
        user.save!
        user2 = User.new user_attributes
        expect { user2.save! email: 'example@example.com' }.to \
         raise_error ActiveRecord::RecordInvalid
      end

      it 'requires @' do
        user.email = 'noat'
        expect(user).not_to be_valid
      end
    end

    context 'password' do
      it('present') do
        # Bug you can't assign a nil password you can initialize it with
        # empty string
        # stackoverflow.com why-is-password-validate-presence-ignored
        user = User.new  password: ''
        expect(user).not_to be_valid
      end

      it 'must equal confirmation' do
        user.password = 'something'
        user.password_confirmation = 'orother'
        expect(user).to_not be_valid
      end
    end
  end

end
