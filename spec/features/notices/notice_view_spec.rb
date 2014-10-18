require 'rails_helper'

describe Notice, type: :feature do

  context '#view' do
    it 'finds notice data' do

      log_in admin_attributes
      template_create id: 2
      notice_create id: 1

      visit '/templates/2'
      expect(page.title). to eq 'Letting - View Invoice Text'
      expect(page).to have_text 'ins1'
      expect(page).to have_text 'This is useful'
      expect(page).to have_text 'Filled'
    end
  end
end
