require 'rails_helper'

describe 'ChargedIn Factory' do

  let(:charged_in) { charged_in_create name: 'Advance' }
  it('is valid') { expect(charged_in).to be_valid }

end
