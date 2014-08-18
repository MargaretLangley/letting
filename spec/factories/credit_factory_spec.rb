require 'rails_helper'

describe 'Credit Factory' do

  let(:credit) { credit_new }
  it('is valid') { expect(credit).to be_valid }

end
