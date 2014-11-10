require 'rails_helper'

describe Template, type: :feature do

  before(:each) do
    log_in admin_attributes
  end

  describe '#update page 2' do
    it 'finds data on 2nd page and succeeds' do
      template_create id: 2
      guide_create instruction: 'ins1'
      guide_create fillin: 'Useful'
      guide_create sample: 'Sample'
      visit '/templates/2/edit'
      # expect(page.title). to eq 'Letting - Edit Invoice Text'
      # click_on 'Update Invoice Text'
      # expect(page).to have_text /successfully updated!/i
    end
  end

  it 'finds data on 2nd page and allows blank' do
    template_create id: 2
    guide_create instruction: 'ins2'
    visit '/templates/2/edit'
    # expect(page.title).to eq 'Letting - Edit Invoice Text'
    # guide_create instruction: ''
    # guide_create fillin: ''
    # guide_create sample: ''
    # click_on 'Update Invoice Text'
    # expect(page).to have_text /successfully updated!/i
  end
end
