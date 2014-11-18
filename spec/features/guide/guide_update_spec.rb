require 'rails_helper'

describe Template, type: :feature do

  before(:each) do
    log_in admin_attributes
  end

  describe '#update page 1' do
    it 'finds data on 1st page and succeeds' do
      template_create id: 1
      guide_create instruction: 'ins1'
      guide_create fillin: 'Useful'
      guide_create sample: 'Sample'
      visit '/templates/1/edit'
      expect(page.title). to eq 'Letting - Edit Invoice Text'
      click_on 'Update Invoice Text'
      expect(page).to have_text /successfully updated!/i
    end
  end
end
