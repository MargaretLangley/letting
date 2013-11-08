require 'spec_helper'
require_relative '../shared/address'

describe Property do

  before(:each) { log_in }

  context '#index' do

    it 'basic' do
      visit '/accounts/'
      expect(page).to have_text 'Accounts Index'
    end

  end

end
