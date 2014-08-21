require 'rails_helper'

describe 'Debit Factory' do

  let(:debit) { debit_new }
  it('is valid') { expect(debit).to be_valid }

end
