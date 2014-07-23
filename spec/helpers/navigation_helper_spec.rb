require 'spec_helper'

describe NavigationHelper, type: :helper do
  describe '#active_nav?' do
    it 'returns "active" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(active_nav? 'accounts').to include 'active-nav'
    end
    it 'returns "inactive" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(active_nav? 'accounts').to include 'inactive-nav'
    end
  end

  describe '#menu_hidden?' do
    it 'returns "flatten" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(menu_folded? 'accounts').to include 'flatten'
    end
    it 'returns "folded" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(menu_folded? 'accounts').to include 'folded'
    end
  end
end
