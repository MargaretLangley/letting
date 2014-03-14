require 'spec_helper'

describe Sheet do
  before(:each) { log_in }

  context '#view' do
    it 'finds data ok' do
       sheet = sheet_factory
       visit "/sheets/#{sheet.id}"
      expect(page).to have_text 'Good Speed'
    end
  end
end
