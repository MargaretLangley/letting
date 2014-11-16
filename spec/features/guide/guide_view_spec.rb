require 'rails_helper'

describe Guide, type: :feature do

  context '#view' do
    it 'finds guide data' do

      log_in admin_attributes
      template_create id: 1
      template_create id: 2
      guide_create id: 1,
                   instruction: 'ins1',
                   fillin: 'This is useful',
                   sample: 'Filled'

      visit '/templates/2'
      expect(page.title). to eq 'Letting - View Invoice Text'
      expect(page).to have_text 'ins1'
      expect(page).to have_text 'This is useful'
      expect(page).to have_text 'Filled'
    end
  end
end
