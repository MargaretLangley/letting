require 'rails_helper'

describe NavigationHelper, type: :helper do
  describe '#main_menu_active?' do
    it 'returns "active" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(main_menu_active? 'accounts').to include 'active-nav'
    end
    it 'returns "inactive" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(main_menu_active? 'accounts').to include 'inactive-nav'
    end
  end

  describe '#menu_hidden?' do
    it 'returns "flatten" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(sub_menu_state 'accounts').to include 'flatten'
    end
    it 'returns "folded" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(sub_menu_state 'accounts').to include 'folded'
    end
  end
end
