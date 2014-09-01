require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in
    sheet_create id: 1,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Bell',
                 phone: '01710008',
                 vat: '89',
                 heading2: 'give you notice pursuant'
  end

  context '#view' do
    it 'finds view page 1' do
      # visit '/sheets/1'
      # expect(page).to have_text 'Estates Ltd'
      # expect(page).to have_text 'Page2 head1'
      # click_on('Edit')
      # expect(find_field('1st Text Block').value).to have_text 'Bowled Out!'
    end
  end

end
