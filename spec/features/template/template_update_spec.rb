require 'rails_helper'

describe Template, type: :feature do

  before(:each) do
    log_in admin_attributes
  end

  describe '#update page 1' do
    it 'finds data on 1st page' do
      template_create id: 1, vat: '89', address: address_new(road: 'High')
      visit '/templates/1/edit'
      expect(page.title).to eq 'Letting - Edit Invoice Text'
      expect(find_field('VAT').value).to have_text '89'
      expect(find_field('Road').value).to have_text 'High'
    end

    it 'has views link' do
      template_create id: 1
      visit '/templates/1/edit'
      expect(page.title).to eq 'Letting - Edit Invoice Text'
      click_on('View')
      expect(page.title).to eq 'Letting - View Invoice Text'
    end
  end

  describe '#update page 2' do
    it 'finds data on 2nd page and succeeds' do
      template_create id: 1
      template_create id: 2
      guide_create id: 1
      visit '/templates/2/edit'
      expect(page.title). to eq 'Letting - Edit Invoice Text'
      fill_in '2nd Heading', with: 'Bowled Out!'
      click_on 'Update Invoice Text'
      expect(page).to have_text /created|updated/i
    end
  end

  it 'finds data on 2nd page and errors' do
    template_create id: 2
    guide_create instruction: 'ins2'
    visit '/templates/2/edit'
    expect(page.title).to eq 'Letting - Edit Invoice Text'
    fill_in '1st Heading', with: ''
    click_on 'Update Invoice Text'
    expect(page).to have_css '[data-role="errors"]'
  end
end
